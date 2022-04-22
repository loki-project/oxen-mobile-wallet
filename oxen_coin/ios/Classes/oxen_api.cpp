#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <chrono>
#include <functional>
#include <iostream>
#include <unistd.h>
#include <thread>
// #include "OxenWalletListener.h"
#ifdef ANDROID
#include "../External/android/oxen/include/wallet2_api.h"
#else
#include "../External/ios/oxen/include/wallet2_api.h"
#endif

namespace Oxen = Wallet;

// Macro to force symbol visibility, and prevent the symbol being stripped
#define EXPORT __attribute__((visibility("default"))) __attribute__((used))

extern "C"
{
    typedef struct
    {
        bool good;
        char error[1023];
    } status_and_error;

    void set_error(status_and_error& sae, std::string_view error) {
        size_t len = std::min(error.size(), sizeof(sae.error)-1);
        std::memcpy(sae.error, error.data(), len);
        sae.error[len] = '\0';
    }
    status_and_error make_status_and_error(bool good, std::string_view error) {
        status_and_error sae;
        sae.good = good;
        set_error(sae, error);
        return sae;
    }
    status_and_error make_good_status() {
        return make_status_and_error(true, "");
    }
    status_and_error make_fail_status(std::string_view error) {
        return make_status_and_error(false, error);
    }

    struct SubaddressRow
    {
        uint64_t id;
        char *address;
        char *label;

        SubaddressRow(std::size_t _id, char *_address, char *_label)
        {
            id = static_cast<uint64_t>(_id);
            address = _address;
            label = _label;
        }
    };

    struct AccountRow
    {
        uint64_t id;
        char *label;

        AccountRow(std::size_t _id, char *_label)
        {
            id = static_cast<uint64_t>(_id);
            label = _label;
        }
    };

    struct OxenWalletListener : Oxen::WalletListener
    {
        uint64_t m_height;
        bool m_need_to_refresh;
        bool m_new_transaction;

        OxenWalletListener()
        {
            m_height = 0;
            m_need_to_refresh = false;
            m_new_transaction = false;
        }

        void moneySpent(const std::string &txId, uint64_t amount)
        {
            m_new_transaction = true;
        }

        void moneyReceived(const std::string &txId, uint64_t amount)
        {
            m_new_transaction = true;
        }

        void unconfirmedMoneyReceived(const std::string &txId, uint64_t amount)
        {
            m_new_transaction = true;
        }

        void newBlock(uint64_t height)
        {
            m_height = height;
        }

        void updated()
        {
            m_new_transaction = true;
        }

        void refreshed()
        {
            m_need_to_refresh = true;
        }

        void resetNeedToRefresh()
        {
            m_need_to_refresh = false;
        }

        bool isNeedToRefresh()
        {
            return m_need_to_refresh;
        }

        bool isNewTransactionExist()
        {
            return m_new_transaction;
        }

        void resetIsNewTransactionExist()
        {
            m_new_transaction = false;
        }

        uint64_t height()
        {
            return m_height;
        }
    };

    struct TransactionInfoRow
    {
        uint64_t amount;
        uint64_t fee;
        uint64_t blockHeight;
        uint64_t confirmations;
        uint32_t subaddrAccount;
        int8_t direction;
        int8_t isPending;
        int8_t isStake;

        // The actual amount of transfers; unlike `amount`, this is *not* net of amounts received in
        // the same transaction; in particular this is useful for stakes (since a stake is a
        // transfers to the same wallet) and sweeps (again which go to the same wallet).  This info,
        // however, is only available in the cache (i.e. it is not synced to the blockchain) so a 0
        // here should be treated as a "don't know" value.
        uint64_t transferAmount;

        char *hash;
        char *paymentId;

        int64_t datetime;

        TransactionInfoRow(Oxen::TransactionInfo *transaction)
        {
            amount = transaction->amount();
            fee = transaction->fee();
            blockHeight = transaction->blockHeight();
            subaddrAccount = transaction->subaddrAccount();
            confirmations = transaction->confirmations();
            datetime = static_cast<int64_t>(transaction->timestamp());            
            direction = transaction->direction();
            isPending = static_cast<int8_t>(transaction->isPending());
            isStake = static_cast<int8_t>(transaction->isStake());
            transferAmount = 0;
            for (auto& t : transaction->transfers())
                transferAmount += t.amount;
            std::string *hash_str = new std::string(transaction->hash());
            hash = strdup(hash_str->c_str());
            paymentId = strdup(transaction->paymentId().c_str());
        }
    };

    struct PendingTransactionRaw
    {
        uint64_t amount;
        uint64_t fee;
        char *hash;
        Oxen::PendingTransaction *transaction;

        PendingTransactionRaw(Oxen::PendingTransaction *_transaction)
        {
            transaction = _transaction;
            amount = _transaction->amount();
            fee = _transaction->fee();
            hash = strdup(_transaction->txid()[0].c_str());
        }
    };

    struct StakeRow
    {
        char *service_node_key;
        uint64_t amount;
        uint64_t unlock_height;
        bool awaiting;
        bool decommissioned;

        explicit StakeRow(const Wallet::Wallet::stake_info& info) :
            service_node_key{strdup(info.sn_pubkey.c_str())},
            amount{info.stake},
            unlock_height{info.unlock_height.value_or(0)},
            awaiting{info.awaiting},
            decommissioned{info.decommissioned}
        {}
    };

    struct StakeUnlockResult
    {
      bool success;
      char *msg;
      Oxen::PendingTransaction *pendingTransaction;

      StakeUnlockResult(bool _success, char *_msg,  Oxen::PendingTransaction *_pendingTransaction)
      {
        success = _success;
        msg = _msg;
        pendingTransaction = _pendingTransaction;
      }
    };

    Oxen::Wallet *m_wallet;
    Oxen::TransactionHistory *m_transaction_history;
    OxenWalletListener *m_listener;
    Oxen::Subaddress *m_subaddress;
    Oxen::SubaddressAccount *m_account;
    uint64_t m_last_known_wallet_height;
    uint64_t m_cached_syncing_blockchain_height = 0;
    std::mutex store_mutex;


    void change_current_wallet(Oxen::Wallet *wallet)
    {
        m_wallet = wallet;
        m_listener = nullptr;
        

        if (wallet != nullptr)
        {
            m_transaction_history = wallet->history();
        }
        else
        {
            m_transaction_history = nullptr;
        }

        if (wallet != nullptr)
        {
            m_account = wallet->subaddressAccount();
        }
        else
        {
            m_account = nullptr;
        }

        if (wallet != nullptr)
        {
            m_subaddress = wallet->subaddress();
        }
        else
        {
            m_subaddress = nullptr;
        }
    }

    EXPORT
    Oxen::Wallet *get_current_wallet()
    {
        return m_wallet;
    }

    EXPORT
    status_and_error create_wallet(char *path, char *password, char *language, int32_t networkType)
    {
        Oxen::NetworkType _networkType = static_cast<Oxen::NetworkType>(networkType);
        Oxen::WalletManagerBase *walletManager = Oxen::WalletManagerFactory::getWalletManager();
        Oxen::Wallet *wallet = walletManager->createWallet(path, password, language, _networkType);

        auto stat = wallet->status();

        if (stat.first != Oxen::Wallet::Status_Ok)
            return make_fail_status(stat.second);

        walletManager->closeWallet(wallet);
        wallet = walletManager->openWallet(path, password, _networkType);

        stat = wallet->status();

        if (stat.first != Oxen::Wallet::Status_Ok)
            return make_fail_status(stat.second);

        change_current_wallet(wallet);

        return make_good_status();
    }

    EXPORT
    status_and_error restore_wallet_from_seed(char *path, char *password, char *seed, int32_t networkType, uint64_t restoreHeight)
    {
        Oxen::NetworkType _networkType = static_cast<Oxen::NetworkType>(networkType);
        Oxen::Wallet *wallet = Oxen::WalletManagerFactory::getWalletManager()->recoveryWallet(
            path, password, seed, _networkType, restoreHeight);

        auto [status, errorString] = wallet->status();

        if (status != Oxen::Wallet::Status_Ok)
        {
            return make_fail_status(errorString);
        }

        change_current_wallet(wallet);
        return make_good_status();
    }

    EXPORT
    status_and_error restore_wallet_from_keys(char *path, char *password, char *language, char *address, char *viewKey, char *spendKey, int32_t networkType, uint64_t restoreHeight)
    {
        Oxen::NetworkType _networkType = static_cast<Oxen::NetworkType>(networkType);
        Oxen::Wallet *wallet = Oxen::WalletManagerFactory::getWalletManager()->createWalletFromKeys(
            std::string(path),
            std::string(password),
            std::string(language),
            _networkType,
            (uint64_t)restoreHeight,
            std::string(address),
            std::string(viewKey),
            std::string(spendKey));


        auto [status, errorString] = wallet->status();

        if (status != Oxen::Wallet::Status_Ok || !errorString.empty())
            return make_fail_status(errorString);

        change_current_wallet(wallet);
        return make_good_status();
    }

    EXPORT
    void load_wallet(char *path, char *password, int32_t nettype)
    {
        nice(19);
        Oxen::NetworkType networkType = static_cast<Oxen::NetworkType>(nettype);
        Oxen::Wallet *wallet = Oxen::WalletManagerFactory::getWalletManager()->openWallet(std::string(path), std::string(password), networkType);
        change_current_wallet(wallet);
    }

    EXPORT
    bool is_wallet_exist(char *path)
    {
        return Oxen::WalletManagerFactory::getWalletManager()->walletExists(std::string(path));
    }

    EXPORT
    void close_current_wallet()
    {
        Oxen::WalletManagerFactory::getWalletManager()->closeWallet(get_current_wallet());
        change_current_wallet(nullptr);
    }

    EXPORT
    char *get_filename()
    {
        return strdup(get_current_wallet()->filename().c_str());
    }

    EXPORT
    char *secret_view_key()
    {
        return strdup(get_current_wallet()->secretViewKey().c_str());
    }

    EXPORT
    char *public_view_key()
    {
        return strdup(get_current_wallet()->publicViewKey().c_str());
    }

    EXPORT
    char *secret_spend_key()
    {
        return strdup(get_current_wallet()->secretSpendKey().c_str());
    }

    EXPORT
    char *public_spend_key()
    {
        return strdup(get_current_wallet()->publicSpendKey().c_str());
    }

    EXPORT
    char *get_address(uint32_t account_index, uint32_t address_index)
    {
        return strdup(get_current_wallet()->address(account_index, address_index).c_str());
    }

    EXPORT
    const char *seed()
    {
        return strdup(get_current_wallet()->seed().c_str());
    }

    EXPORT
    uint64_t get_full_balance(uint32_t account_index)
    {
        return get_current_wallet()->balance(account_index);
    }

    EXPORT
    uint64_t get_unlocked_balance(uint32_t account_index)
    {
        return get_current_wallet()->unlockedBalance(account_index);
    }

    EXPORT
    uint64_t get_current_height()
    {
        return get_current_wallet()->blockChainHeight();
    }

    EXPORT
    uint64_t get_node_height()
    {
        return get_current_wallet()->daemonBlockChainHeight();
    }

    EXPORT
    bool is_refreshing()
    {
        return get_current_wallet()->isRefreshing();
    }

    EXPORT
    status_and_error connect_to_node()
    {
        nice(19);
        bool is_connected = get_current_wallet()->connectToDaemon();

        if (!is_connected)
            return make_fail_status(get_current_wallet()->status().second);

        return make_good_status();
    }

    EXPORT
    status_and_error setup_node(char *address, char *login, char *password, bool use_ssl)
    {
        nice(19);
        Oxen::Wallet *wallet = get_current_wallet();
        
        std::string _login = "";
        std::string _password = "";

        if (login != nullptr)
            _login = login;

        if (password != nullptr)
            _password = password;

        bool inited = wallet->init(address, 0, _login, _password, use_ssl);

        if (!inited || !wallet->connectToDaemon())
            return make_fail_status(wallet->status().second);

        return make_good_status();
    }

    EXPORT
    bool is_connected()
    {
        return get_current_wallet()->connected();
    }

    EXPORT
    void start_refresh()
    {
        get_current_wallet()->refreshAsync();
        get_current_wallet()->startRefresh();
    }

    EXPORT
    void set_refresh_from_block_height(uint64_t height)
    {
        get_current_wallet()->setRefreshFromBlockHeight(height);
    }

    EXPORT
    void set_recovering_from_seed(bool is_recovery)
    {
        get_current_wallet()->setRecoveringFromSeed(is_recovery);
    }

    EXPORT
    void store(const char *path = "")
    {
        store_mutex.lock();
        get_current_wallet()->store(std::string(path));
        store_mutex.unlock();
    }

    EXPORT
    int32_t stake_count() {
        std::unique_ptr<std::vector<Wallet::Wallet::stake_info>> stakes{m_wallet->listCurrentStakes()};
        int32_t count = static_cast<int32_t>(stakes->size());
        return count;
    }

    EXPORT
    intptr_t* stake_get_all() {
        std::unique_ptr<std::vector<Wallet::Wallet::stake_info>> stakes{m_wallet->listCurrentStakes()};
        size_t size = stakes->size();
        intptr_t* stakes_out = reinterpret_cast<intptr_t *>(malloc(size * sizeof(intptr_t)));

        for (int i = 0; i < size; i++)
            stakes_out[i] = reinterpret_cast<intptr_t>(new StakeRow((*stakes)[i]));

        return stakes_out;
    }

    EXPORT
    status_and_error stake_create(char *service_node_key, char *amount, PendingTransactionRaw &pendingTransaction)
    {
        nice(19);

        Oxen::PendingTransaction *transaction;

        uint64_t _amount = amount != nullptr
            ? Oxen::Wallet::amountFromString(amount)
            : get_unlocked_balance(0);
        transaction = m_wallet->stakePending(service_node_key, _amount);

        int status = transaction->status().first;

        if (status == Oxen::PendingTransaction::Status::Status_Error || status == Oxen::PendingTransaction::Status::Status_Critical)
        {
            return make_fail_status(transaction->status().second);
        }

        pendingTransaction = PendingTransactionRaw(transaction);
        return make_good_status();
    }

    EXPORT
    bool can_request_stake_unlock(char *service_node_key)
    {
        std::unique_ptr<Oxen::StakeUnlockResult> stakeUnlockResult{m_wallet->canRequestStakeUnlock(service_node_key)};
        return stakeUnlockResult->success();
    }

    EXPORT
    status_and_error submit_stake_unlock(char *service_node_key, PendingTransactionRaw &pendingTransaction)
    {
        std::unique_ptr<Oxen::StakeUnlockResult> stakeUnlockResult{m_wallet->requestStakeUnlock(service_node_key)};

        if (stakeUnlockResult->success())
        {
            pendingTransaction = stakeUnlockResult->ptx();
            return make_good_status();
        }
        return make_fail_status(stakeUnlockResult->msg());
    }

    EXPORT
    uint64_t transaction_estimate_fee(uint32_t priority, uint32_t recipients)
    {
        return m_wallet->estimateTransactionFee(priority, recipients);
    }

    EXPORT
    status_and_error transaction_create(char *address, char *amount, uint8_t priority, uint32_t subaddr_account,
        PendingTransactionRaw &pendingTransaction)
    {
        nice(19);

        Oxen::PendingTransaction *transaction;

        std::optional<uint64_t> amt;
        if (amount != nullptr)
            amt = Oxen::Wallet::amountFromString(amount);

        transaction = m_wallet->createTransaction(address, amt, priority, subaddr_account);

        int status = transaction->status().first;

        if (status == Oxen::PendingTransaction::Status::Status_Error || status == Oxen::PendingTransaction::Status::Status_Critical)
        {
            return make_fail_status(transaction->status().second);
        }

        pendingTransaction = PendingTransactionRaw(transaction);
        return make_good_status();
    }

    EXPORT
    status_and_error transaction_commit(PendingTransactionRaw *transaction)
    {
        status_and_error result = make_status_and_error(transaction->transaction->commit(), "");

        if (!result.good)
            set_error(result, transaction->transaction->status().second);
        else if (m_listener)
            m_listener->m_new_transaction = true;

        return result;
    }

    EXPORT
    uint64_t get_node_height_or_update(uint64_t base_height)
    {
        if (m_cached_syncing_blockchain_height < base_height) {
            m_cached_syncing_blockchain_height = base_height;
        }

        return m_cached_syncing_blockchain_height;
    }

    EXPORT
    uint64_t get_syncing_height()
    {
        if (m_listener == nullptr) {
            return 0;
        }

        uint64_t height = m_listener->height();

        if (height <= 1) {
            return 0;
        }

        if (height != m_last_known_wallet_height)
        {
            m_last_known_wallet_height = height;
        }

        return height;
    }

    EXPORT
    uint64_t is_needed_to_refresh()
    {
        if (m_listener == nullptr) {
            return false;
        }

        bool should_refresh = m_listener->isNeedToRefresh();

        if (should_refresh) {
            m_listener->resetNeedToRefresh();
        }

        return should_refresh;
    }

    EXPORT
    uint8_t is_new_transaction_exist()
    {
        if (m_listener == nullptr) {
            return false;
        }

        bool is_new_transaction_exist = m_listener->isNewTransactionExist();

        if (is_new_transaction_exist)
        {
            m_listener->resetIsNewTransactionExist();
        }

        return is_new_transaction_exist;
    }

    EXPORT
    void set_listener()
    {
        m_last_known_wallet_height = 0;

        if (m_listener != nullptr)
        {
             free(m_listener);
        }

        m_listener = new OxenWalletListener();
        get_current_wallet()->setListener(m_listener);
    }

    EXPORT
    int64_t *subaddress_get_all()
    {
        std::vector<Oxen::SubaddressRow *> _subaddresses = m_subaddress->getAll();
        size_t size = _subaddresses.size();
        int64_t *subaddresses = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Oxen::SubaddressRow *row = _subaddresses[i];
            SubaddressRow *_row = new SubaddressRow(row->getRowId(), strdup(row->getAddress().c_str()), strdup(row->getLabel().c_str()));
            subaddresses[i] = reinterpret_cast<int64_t>(_row);
        }

        return subaddresses;
    }

    EXPORT
    int32_t subaddress_size()
    {
        std::vector<Oxen::SubaddressRow *> _subaddresses = m_subaddress->getAll();
        return static_cast<int32_t>(_subaddresses.size());
    }

    EXPORT
    void subaddress_add_row(uint32_t accountIndex, char *label)
    {
        m_subaddress->addRow(accountIndex, std::string(label));
    }

    EXPORT
    void subaddress_set_label(uint32_t accountIndex, uint32_t addressIndex, char *label)
    {
        m_subaddress->setLabel(accountIndex, addressIndex, std::string(label));
    }

    EXPORT
    void subaddress_refresh(uint32_t accountIndex)
    {
        m_subaddress->refresh(accountIndex);
    }

    EXPORT
    int32_t account_size()
    {
        return static_cast<int32_t>(m_account->getAll().size());
    }

    EXPORT
    int64_t *account_get_all()
    {
        std::vector<Oxen::SubaddressAccountRow *> _accounts = m_account->getAll();
        size_t size = _accounts.size();
        int64_t *accounts = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Oxen::SubaddressAccountRow *row = _accounts[i];
            AccountRow *_row = new AccountRow(row->getRowId(), strdup(row->getLabel().c_str()));
            accounts[i] = reinterpret_cast<int64_t>(_row);
        }

        return accounts;
    }

    EXPORT
    void account_add_row(char *label)
    {
        m_account->addRow(std::string(label));
    }

    EXPORT
    void account_set_label_row(uint32_t account_index, char *label)
    {
        m_account->setLabel(account_index, label);
    }

    EXPORT
    void account_refresh()
    {
        m_account->refresh();
    }

    EXPORT
    int64_t *transactions_get_all()
    {
        std::vector<Oxen::TransactionInfo *> transactions = m_transaction_history->getAll();
        size_t size = transactions.size();
        int64_t *transactionAddresses = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Oxen::TransactionInfo *row = transactions[i];
            TransactionInfoRow *tx = new TransactionInfoRow(row);
            transactionAddresses[i] = reinterpret_cast<int64_t>(tx);
        }

        return transactionAddresses;
    }

    EXPORT
    void transactions_refresh()
    {
        m_transaction_history->refresh();
    }

    EXPORT
    int64_t transactions_count()
    {
        return m_transaction_history->count();
    }

    EXPORT
    void on_startup(void)
    {
        Oxen::Utils::onStartup();
        Oxen::WalletManagerFactory::setLogLevel(0);
    }

    EXPORT
    void rescan_blockchain()
    {
        m_wallet->rescanBlockchainAsync();
    }

    EXPORT
    char * get_tx_key(char * txId)
    {
        return strdup(m_wallet->getTxKey(std::string(txId)).c_str());
    }

}
