#include <string>
#include <iostream>
#include "BandwidthDb.h"

using namespace std;

void usage(char *name) {
  cerr << "Usage: " << name << " [-c]" << endl;
}

int main(int argc, char **argv) {
  BandwidthDbEnv dbenv("/home/virality/image_bw/db");
  BandwidthDb db(&dbenv, "bandwidth.db");
  int c;
  bool clear = false;

  while ((c = getopt(argc, argv, "c")) != -1) {
    switch (c) {
    case 'c':
      clear = true;
      break;
    default:
      usage(argv[0]);
      exit(1);
    }
  }
  db.dump(cout);
  if (clear) {
    db.reset();
  }
  return 0;
}
