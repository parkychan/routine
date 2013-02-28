#include <string>
#include <iostream>
#include <getopt.h>
#include <boost/lexical_cast.hpp>
#include "BandwidthDb.h"

using namespace std;
using boost::lexical_cast;

#define BUF_SIZE 16*1024

void usage(char *name) {
  cerr << "Usage: " << name << " [-r] [-l loadfile]" << endl;
}

char *trim_referer(char *referer) {
  // trim referer 
  if (strncmp(referer, "\"http://", 8) == 0) {
    referer += 8;
  } else if (strncmp(referer, "\"https://", 9) == 0) {
    referer += 9;
  }
  char *qmark = strchr(referer, '?');
  if (qmark)
    *qmark = '\0';
  qmark = strchr(referer, '"');
  if (qmark)
    *qmark = '\0';
  return referer;
}

char *trim_hostname(char *hostname) {
  if (strncmp(hostname, "img.", 4) == 0) {
    hostname += 4;
  }
  if (strcmp(hostname, "6waves.com") == 0) {
    hostname[6] = '\0';
  } else {
    char *d = strstr(hostname, ".6waves.com");
    if (d) {
      *d = '\0';
    }
  }
  return hostname;
}

void process_log_entry(BandwidthDb &db, char *buf, bool log_referer) {
  char *hostname, *url, *referer, *bytes;
  char *cur;
  cur = buf;
  hostname = strtok(buf, " \n");
  if (hostname == NULL) return;
  url = strtok(NULL, " \n");
  if (url == NULL) return; 
  referer = strtok(NULL, "\" ");
  if (referer == NULL) return;
  bytes = strtok(NULL, " \n");
  if (bytes == NULL) return;
  unsigned long nbytes = 0;

  try {
    nbytes = lexical_cast<unsigned long>(bytes);
  } catch (exception &e) {
    cerr << "bad lexical cast: " << bytes << endl;
    return;
  }

  referer = trim_referer(referer);
  hostname = trim_hostname(hostname);

  if (nbytes > 0) {
    db.addToDomain(hostname, nbytes);
    if (log_referer) {
      db.addToDomainReferer(hostname, referer, nbytes);
    }
  }
}

int main(int argc, char **argv) {
  char *loadfile = NULL;
  bool log_referer = false;
  int c;
  char buf[BUF_SIZE];
  BandwidthDbEnv dbenv("/home/virality/image_bw/db");
  BandwidthDb db(&dbenv, "bandwidth.db");

  while ((c = getopt(argc, argv, "hrl:")) != -1) {
    switch (c) {
    case 'h':
      usage(argv[0]);
      exit(0);
      break;
    case 'r': // process referer
      log_referer = true;
      break;
    case 'l': // load file
      loadfile = optarg;
      break;
    default:
      usage(argv[0]);
      exit(1);
    }
  }
  FILE *f = fopen("/tmp/bwcounter.txt", "a");

  while (true) {
    char *s = fgets(buf, BUF_SIZE, stdin);
    if (s == NULL) {
      int status = ferror(stdin);
      fprintf(f, "status = %d\n", status);
      break;
    }
    process_log_entry(db, buf, log_referer);
  }

  fprintf(f, "EXIT!\n");
  fclose(f);
  return 0;
}
    
  
