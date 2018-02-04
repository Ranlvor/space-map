#!/bin/sh
if [ "$TRAVIS_SECURE_ENV_VARS" != "true" ]; then
  echo "TRAVIS_SECURE_ENV_VARS not available. Aborting artifact upload."
  exit
fi

#unpack autorisation information
cat > netrc.gpg <<EOF
-----BEGIN PGP MESSAGE-----
Version: GnuPG v1

hQQMA10L0QBKvnhZAR/9HC1IhQQ33vzKaNoH71FtOT3kePJUUmb65FWef1mP0Avu
0l1lLr1R3KYdRcLy/2w+FIAm8Pu2McjPyLiW7F3khg4ntT6xyDupqtoiM4CzNCXV
ffYviWedc5Fav5USQLQUTBOztoQNnWZN3lch0CnU9k5C6Ly4YABb/U2Ron80eJBN
cU/UQpPQ92+l8WkjEYzFYnsbsPreejGw7Mg7tTMEnZ/Xgex7MI15JKKIEV6qwzFV
N1k54V2EJUbJhZWxVc76EOW1gisIt7Sla2N5oa3T51j4QpQ1xkvPDGZ/TmhU1yWM
CGHnXNrKoSAqj7RIKCtFJIeFiAKdAuBYjOMiGsZmwO8l9Bbs1Kpn4Q0Q/wgIgHMK
hZ4Px8VGQR4q/CI0A8BH9a5JlFjIThh2CYYthhp/4vf8bRSS5H1iJ73zqaZjh2f+
cRzMJa9sije1q0A84bQN7wgZsPuohXXBY0riHe2/7m6KZ2xTv5JUzbZJJ2vNTcMZ
Htw/c8+nG0u+r84lJkDWbXSHfa16bGEBd363tClXEx8zlO7ls1KgGripk6R/j2L/
bgIV3FEmpkJxfd0flgImVuh8eJhZnX8CjJDM3BWXPRx+imritKq0iBB7fnRqBy4g
1aq2oieYrEZg6dQcMnzxxp6Aj2hC1p5mLoTriQv1mOYowDRbhWi5E7ULJPBMZF4H
RTRPeKWV7gPrGxEC82SaV9HLaH0c/XizSyGDEGblorymHY7dxPfxvU+67OofDP6N
HbmqJT/Ais3huTW4ljhLO2fxRaV8/PiZzRX4i12jA2YzQkuMeOMjFlI3yrwy2ZhT
CDOcmEYiVa8icPO3Xwit8SBS/qNgVdiGroGwEzBiPhSvZ3kboCIO8nbxDEo7LTr6
6TGOxQfHdF5Q7pOiPDOme/CD6apQTLH6MNU5Gd/GBwf8EnqPFAGE38p976c8G7V6
YQU5P7bn/tG6XTpLMzXTyYkeIqSYtBRZD78j0f60p4Wt6tIYyNeTdkHcd4RlspON
zlxmetWIez7kfsN3O/ijFJlkzPzhPN+KqO0uRpX/rFIuwoZcSznNqZwVRuHs5Y6d
5zYTpfWWuwQiA2fBkofRw29KqKyu3V2jSZfozE4KGRdlvAjCKaZVyyhszL/T90TL
d//L1b/0A1auXl+3Qlllu9/8SSIn255552AZ4twQwq17TEu/4zWAbmicS7N+wLUN
0Xj8bqCiR1K/4kKiMqNGxR9S94iyWUqkF9KRxOeJRWtTxZBOplZAWybaDNsFVoxF
xhbl5kPZ7z37F61LO8r2kHCLD37nNuurgbkamE+zosc+YEGxuWq2CMAU6XE7SYdG
q+wisePUZcLgurI39DJwTIyhjKM1wpw5QKn08kkYKIwuBAcDAlcq4V0jUEkZYD0X
pPnIJGl8NdI1GL5KequGkndish1Xg3Pc28dD2tnEodKVAa0MDh7l4k5TOQsEB21P
436XILA4YwiLLyaNzw77tKO1sOC0/Jc5RWPfRW9A5KWvmkLuo0n6WRez7C2Tgjcb
lnTwKW90IO4AF7QcwKhkjBtNVIlhxV4IR39ws3Eks1ZVXL0lwfQuvKgjCWudckVO
CfX78VH2GVFWxOsoGz1aecs0FpUpDS49w+q9eue52CTDKdFY/Ys=
=gY7O
-----END PGP MESSAGE-----
EOF
echo $DEPLOY_ENCRYPTION_KEY | gpg -q --passphrase-fd 0 netrc.gpg
mv netrc ~/.netrc

#load and patch davpush
curl https://raw.githubusercontent.com/ptillemans/davpush/master/davpush.pl | sed 's-#dav://-#https://-' > davpush.pl
chmod +x davpush.pl

#prepare upload
cd artifacts
mkdir -p $TRAVIS_COMMIT/node_$TRAVIS_NODE_VERSION
mv *js $TRAVIS_COMMIT/node_$TRAVIS_NODE_VERSION

#upload artifacts
../davpush.pl https://cloud.starletp9.de/remote.php/webdav/build-artifacts/

