#ifndef BANDWIDTH_DB_H
#define BANDWIDTH_DB_H
#include <db_cxx.h>
#include <string>
#include <pthread.h>

using namespace std;

class BandwidthDbEnv : public DbEnv {
 public:
  BandwidthDbEnv(const string &home);
  ~BandwidthDbEnv();
  static void *checkpoint_thread(void *);
};

class BandwidthDb : public Db {
 public:
  BandwidthDb(BandwidthDbEnv *env, const string &filename);
  virtual ~BandwidthDb();

  virtual void addToDomain(const string &domain, unsigned long bytes);
  virtual void addToDomainReferer(const string &domain, const string &referer, unsigned long bytes);

  void reset();
  void dump(ostream &os);

 private:
  void incrementKey(const string &key, unsigned long value);
  BandwidthDbEnv *dbenv;
};

#endif
