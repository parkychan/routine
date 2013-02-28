#include "BandwidthDb.h"
#include <sys/stat.h>

void *BandwidthDbEnv::checkpoint_thread(void *arg) {
  DbEnv *dbenv = (DbEnv *)arg;
  while (true) {
    sleep(60);
    dbenv->txn_checkpoint(0,0,0);
  }
  return NULL;
}

BandwidthDbEnv::BandwidthDbEnv(const string &home)
  : DbEnv(0) {
  mkdir(home.c_str(), 0777);
  set_timeout(5000000,DB_SET_LOCK_TIMEOUT);
  set_timeout(5000000,DB_SET_TXN_TIMEOUT);
  //  set_flags(DB_AUTO_COMMIT,1);
  set_lk_detect(DB_LOCK_OLDEST);

  //set_flags(DB_DIRECT_DB,1);

  //  open(home.c_str(),DB_CREATE|DB_INIT_TXN|DB_INIT_LOG|DB_INIT_MPOOL|DB_INIT_LOCK|DB_THREAD|DB_RECOVER_FATAL,0);
  open(home.c_str(),DB_CREATE|DB_INIT_MPOOL|DB_THREAD,0);
  /*
  pthread_t ptid;
  pthread_create(&ptid, NULL, checkpoint_thread, (void *)this);
  */
}

BandwidthDbEnv::~BandwidthDbEnv() {
  close(0);
}

BandwidthDb::BandwidthDb(BandwidthDbEnv *env, const string &filename)
  : Db(env, 0), dbenv(env) {
  open(NULL, filename.c_str(), NULL, DB_HASH, DB_CREATE | DB_THREAD, 0);
}

BandwidthDb::~BandwidthDb() {
  close(0);
}

void BandwidthDb::addToDomain(const string &domain, unsigned long bytes) {
  this->incrementKey("d:"+domain, bytes);
}

void BandwidthDb::addToDomainReferer(const string &domain, const string &referer, unsigned long bytes) {
  this->incrementKey("dr:"+domain+"|"+referer, bytes);
}

void BandwidthDb::incrementKey(const string &key, unsigned long value) {
  Dbt dbkey((void*)key.c_str(), key.length());
  Dbt dbvalue;
  unsigned long num;
  dbvalue.set_data(&num);
  dbvalue.set_ulen(sizeof(num));
  dbvalue.set_flags(DB_DBT_USERMEM);

  //  DbTxn *txn = NULL;
  //  dbenv->txn_begin(NULL, &txn, 0);
  try {
    if (this->get(NULL, &dbkey, &dbvalue, 0) != DB_NOTFOUND) {
      num += value;
    } else {
      num = value;
    }

    Dbt dbnewvalue(&num, sizeof(num));
    this->put(NULL, &dbkey, &dbnewvalue, 0);
    //    txn->commit(0);
  } catch (exception &e) {
    //    txn->abort();
  }
}

void BandwidthDb::dump(ostream &os) {
  Dbc *cursorp;
  DbTxn *txn = NULL;
  //  dbenv->txn_begin(NULL, &txn, 0);
  try {
    this->cursor(txn, &cursorp, 0); 

    Dbt key, data;
    int ret;

    unsigned long num;
    data.set_data(&num);
    data.set_ulen(sizeof(num));
    data.set_flags(DB_DBT_USERMEM);

    // Iterate over the database, retrieving each record in turn.
    while ((ret = cursorp->get(&key, &data, DB_NEXT)) == 0) {
      string keystr((char*)key.get_data(), key.get_size());
      unsigned long bytes = *(unsigned long*)data.get_data();
      os << keystr << "\t" << bytes << endl;
    }
    cursorp->close();
    //    txn->commit(0);
  } catch (exception &e) {
    //    txn->abort();
    throw;
  }
}

void BandwidthDb::reset() {
  Dbc *cursorp;
  this->cursor(NULL, &cursorp, 0); 

  Dbt key, data;
  int ret;

  unsigned long num;
  data.set_data(&num);
  data.set_ulen(sizeof(num));
  data.set_flags(DB_DBT_USERMEM);

  while ((ret = cursorp->get(&key, &data, DB_NEXT)) == 0) {
    num = 0;
    data.set_data(&num);
    data.set_size(sizeof(num));
    //cursorp->del(0);
    cursorp->put(&key, &data, DB_CURRENT);
    //this->put(NULL, &key, &data, 0);
  }
  cursorp->close();
}
