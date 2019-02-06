
if dpkg-vendor --derives-from Ubuntu; then
  vendor=Ubuntu
elif dpkg-vendor --derives-from Debian; then
  vendor=Debian
else
  vendor=Unknown
fi

export LOCPATH=$(pwd)/locales
sh $debian_dir/locale-gen

export LANG=C.UTF-8

export DEB_PYTHON_INSTALL_LAYOUT=deb_system

TESTOPTS="-j 1 -w -uall,-network,-urlfetch,-gui"

# test_dbm: Fails from time to time ...
#TESTEXCLUSIONS="$TESTEXCLUSIONS test_dbm"

# test_ensurepip: not yet installed, http://bugs.debian.org/732703
# ... and then test_venv fails too
TESTEXCLUSIONS="$TESTEXCLUSIONS test_ensurepip test_venv "

# test_lib2to3: see https://bugs.python.org/issue34286
TESTEXCLUSIONS="$TESTEXCLUSIONS test_lib2to3"

# test_tcl: see https://bugs.python.org/issue34178
TESTEXCLUSIONS="$TESTEXCLUSIONS test_tcl"

# FIXME: Failing with OpenSSL 1.2 ...
# ssl.SSLError: [SSL: CA_MD_TOO_WEAK] ca md too weak (_ssl.c:3401)
if [ "$vendor" = Debian ]; then
  TESTEXCLUSIONS="$TESTEXCLUSIONS test_asyncio test_ftplib test_httplib test_imaplib test_nntplib test_poplib test_ssl"
fi

# FIXME: testWithTimeoutTriggeredSend: timeout not raised by _sendfile_use_sendfile
TESTEXCLUSIONS="$TESTEXCLUSIONS test_socket"

# FIXME: issue 34806: some distutils tests fail recently
TESTEXCLUSIONS="$TESTEXCLUSIONS test_distutils"

# FIXME, failing on the Ubuntu autopkg testers
if [ "$vendor" = Ubuntu ]; then
  TESTEXCLUSIONS="$TESTEXCLUSIONS test_code_module test_platform test_site"
fi
