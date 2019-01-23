#!/bin/bash

#
#   getshsh.sh - A simple shsh get script.
#   by @dora_ios 2019/01/23
#
#   *test environment
#   *OS                 : OSX 10.10.5 (Yosemite)
#   *tsschecker version : 62805e474982e78d378fea023c3469ffe7a5d078 - 247
#
#   *tsschecker Usage
#   Usage: tsschecker [OPTIONS]
#   Checks (real) signing status of device/firmware
#
#   -d, --device MODEL              specific device by its MODEL (eg. iPhone4,1)
#   -i, --ios VERSION               specific iOS version (eg. 6.1.3)
#       --buildid BUILDID           specific buildid instead of iOS version (eg. 13C75)
#   -B, --boardconfig BOARD         specific boardconfig instead of iPhone model (eg. n61ap)
#   -h, --help                      prints usage information
#   -o, --ota                       check OTA signing status, instead of normal restore
#   -b, --no-baseband               don't check baseband signing status. Request a ticket without baseband
#   -m, --build-manifest            manually specify buildmanifest. (can be used with -d)
#   -s, --save                      save fetched shsh blobs (mostly makes sense with -e)
#   -u, --update-install			request update ticket instead of erase
#   -l, --latest                    use latest public iOS version instead of manually specifying one
#                                   especially useful with -s and -e for saving blobs
#   -e, --ecid ECID                 manually specify ECID to be used for fetching blobs, instead of using random ones
#                                   ECID must be either dec or hex eg. 5482657301265 or ab46efcbf71
#       --apnonce NONCE             manually specify APNONCE instead of using random one (not required for saving blobs)
#       --sepnonce NONCE            manually specify SEPNONCE instead of using random one (not required for saving blobs)
#       --save-path PATH            specify path for saving blobs
#       --generator GEN             manually specify generator in format 0x%16llx
#   -h, --help                      prints usage information
#       --beta                      request ticket for beta instead of normal relase (use with -o)
#       --list-devices              list all known devices
#       --list-ios                  list all known ios versions
#       --nocache                   ignore caches and redownload required files
#       --print-tss-request
#       --print-tss-response
#       --raw                       send raw file to Apple's tss server (useful for debugging)
#

#      *ApNonce List
#       03011429dca6e0e1e71cc99716f27d94131d8128 ## @dora_ios's iPhone6,1
#       7d7bdc28e5eca36dc5bc20c791850f110dc28269
#       1dedf288afea588e803be0737af7ae5ca87d107f
#       6b83f831a6305ae90d57a78ba8eb9d81e7a9058f
#       f5cce05e81a9be2ef66ec287f692ffdf20b13860
#       7ce1657233867e988e1b48988ef98fc28ddf20f5
#       74f5bbf201cbdcb8a145220fdcc6d82c3ce3a9d8
#       72d41d45661d4108ab49a743701b4203862e1651
#       b05a70468054cfe94251b34b58f28450054f1aa9
#       ee4b7f9b2d7d41bfde4c8390734a83d63c2fe997
#       47080312e71eda7ccd8eec33af095f41710fe8db
#       8f760412c8653de657e8ea2352f706de2e9ca85c
#       778282f0cf6e5234446d88ebc5dcfde81f415b57
#       319c24a1e5adadb275b9be2fe82460d4ad068f92
#       0f3b31015974dcc5ceb91c6883d6402621e5f1bb
#       0a6b1027d0758d9f3699d8e40ce1189848190cc0
#       93d5c7ba2844327ccb0a2a705fa8bb186021b459
#       3f808110c6c0e2be97c087be8fa866012f3db5ab
#       efd3060f847c13dbd79b955cc9761a76bb6b9653
#       6b81a2c3cdf87404dee28330f7fcb0ee62c425a1
#       b803b8b5bbb727ebcd70f705f1f03eb45ceeca08
#       83265a110a03fe0d78649d6eefa5094389dcba65
#       ec0ee58adb595a213910f3bcc495c2e5f6c7d608
#       41234383e4311bca58b55807009f68c202d1a4f6
#       16aeb5f04d3d74485d83a3a24db74c95e07ba2b9
#       da218206498ff76001c8ae2e224713c293c5056c
#       2890f2304faeb3ef156006b2ba5225d873ab1e9d
#       d1c243d4e68964a383fe9804dc63d6a359cca4b6
#       be6cd33cfe780486f604015abb9c0910c2a5f6c3
#       ed85a1dfc3119de81f661508c3257705f265ecc2
#       728a82a4bf7246939ea5db839ca782604cd97511
#       8e33f9b17ca3ce754f5e7b4674ff796bc481302f
#       8659875543cddd64b19873fe6e4b1cf811a2d18f
#       a0d98fd69e122797ad6fb27376e83d982d321eff

#       caadf840ba58ff6ca21d498e8f8496f7b0a33277 ## @dora_ios's iPhone6,1
#       4da8b62e458c5b5d280c238ad152ea232e5386f7
#       99b5e22d771c0f1c81f70c394e9907993a2db435
#       e750584ad5e9cefc403a03d9fe5d3b9cc46a3ac4
#       4e7a5f87f93d32bb40f6c518726088c7e15997f5
#       2a18e4781eab79bc8f5f5b0a0ab87a0215974ee8
#       92658e2398b3aa22c7e8299ba6f78fc6fb3f84ed
#       2570ffcb6fbf841ebebac999a4f3e7c220a71a2a
#       1323f3979e87f71b8083fb98487fe3e744e1539a
#       eeb59e528128a79ccb3903799f40d196f51d528d
#       87d2ee06d87e4b81e415f57d6bbd84167b846352
#       ccd8b14ceb4e66c7abf7e22625448b00f2e4b754
#       99cdb2cc94047e80cf0e469aace151d3f819c417
#       02a2b9a3c27d778d31c87d156060dbdd5d6baca4
#       89a10fdaa35ef8fcd4f444bcef7e9c1031f489d0
#       9440dad2b27ac1f7f626a7a11b3df13683721100
#       ad51655059471fd0647599d091df98f73f59c2a8
#       dc1879c6b0b065f037943871f27c1ecbc9e48b14
#       aec09c7811dd02297b80251278608e67d913b74a
#       6d943452cae56d76aace5e6da62da10f47769aa9

#       ce610744ad24931c96d46b20f47d096b0b27487b ## @taichiapple's iPad4,1
#       fcd3d819cb3d2c2d043ccdbaeafe6d8938c3ac1d
#       c067414bc17bc7d65dd036f56b81b522265ba79f
#       42b39f38a9951c205df9d16bcece4422764f1cfd
#       530783a50d36aea82628de2abb90920c3428918d
#       831513e57eddad8652ae3addae987287a0047367
#       198365e19ea223bd73ee27faa555ca24ac6ed65d
#       76b3343a8cd2b25ff65dd493ea2bc18edea77be8
#       1ff89bb136025233f089fa48708d7d217db70895
#       0648939eac93a33ae5a9d6c4f5703f0baa2e68f3
#       8b9244eba18e07f3ad9d5eed4f972aa98f0c495e
#       63e81aabb8e9e45cc756c347e8cdfd9ae7c796ad

ApNonce='
03011429dca6e0e1e71cc99716f27d94131d8128
7d7bdc28e5eca36dc5bc20c791850f110dc28269
1dedf288afea588e803be0737af7ae5ca87d107f
6b83f831a6305ae90d57a78ba8eb9d81e7a9058f
f5cce05e81a9be2ef66ec287f692ffdf20b13860
7ce1657233867e988e1b48988ef98fc28ddf20f5
74f5bbf201cbdcb8a145220fdcc6d82c3ce3a9d8
72d41d45661d4108ab49a743701b4203862e1651
b05a70468054cfe94251b34b58f28450054f1aa9
ee4b7f9b2d7d41bfde4c8390734a83d63c2fe997
47080312e71eda7ccd8eec33af095f41710fe8db
8f760412c8653de657e8ea2352f706de2e9ca85c
778282f0cf6e5234446d88ebc5dcfde81f415b57
319c24a1e5adadb275b9be2fe82460d4ad068f92
0f3b31015974dcc5ceb91c6883d6402621e5f1bb
0a6b1027d0758d9f3699d8e40ce1189848190cc0
93d5c7ba2844327ccb0a2a705fa8bb186021b459
3f808110c6c0e2be97c087be8fa866012f3db5ab
efd3060f847c13dbd79b955cc9761a76bb6b9653
6b81a2c3cdf87404dee28330f7fcb0ee62c425a1
b803b8b5bbb727ebcd70f705f1f03eb45ceeca08
83265a110a03fe0d78649d6eefa5094389dcba65
ec0ee58adb595a213910f3bcc495c2e5f6c7d608
41234383e4311bca58b55807009f68c202d1a4f6
16aeb5f04d3d74485d83a3a24db74c95e07ba2b9
da218206498ff76001c8ae2e224713c293c5056c
2890f2304faeb3ef156006b2ba5225d873ab1e9d
d1c243d4e68964a383fe9804dc63d6a359cca4b6
be6cd33cfe780486f604015abb9c0910c2a5f6c3
ed85a1dfc3119de81f661508c3257705f265ecc2
728a82a4bf7246939ea5db839ca782604cd97511
8e33f9b17ca3ce754f5e7b4674ff796bc481302f
8659875543cddd64b19873fe6e4b1cf811a2d18f
a0d98fd69e122797ad6fb27376e83d982d321eff
caadf840ba58ff6ca21d498e8f8496f7b0a33277
4da8b62e458c5b5d280c238ad152ea232e5386f7
99b5e22d771c0f1c81f70c394e9907993a2db435
e750584ad5e9cefc403a03d9fe5d3b9cc46a3ac4
4e7a5f87f93d32bb40f6c518726088c7e15997f5
2a18e4781eab79bc8f5f5b0a0ab87a0215974ee8
92658e2398b3aa22c7e8299ba6f78fc6fb3f84ed
2570ffcb6fbf841ebebac999a4f3e7c220a71a2a
1323f3979e87f71b8083fb98487fe3e744e1539a
eeb59e528128a79ccb3903799f40d196f51d528d
87d2ee06d87e4b81e415f57d6bbd84167b846352
ccd8b14ceb4e66c7abf7e22625448b00f2e4b754
99cdb2cc94047e80cf0e469aace151d3f819c417
02a2b9a3c27d778d31c87d156060dbdd5d6baca4
89a10fdaa35ef8fcd4f444bcef7e9c1031f489d0
9440dad2b27ac1f7f626a7a11b3df13683721100
ad51655059471fd0647599d091df98f73f59c2a8
dc1879c6b0b065f037943871f27c1ecbc9e48b14
aec09c7811dd02297b80251278608e67d913b74a
6d943452cae56d76aace5e6da62da10f47769aa9
ce610744ad24931c96d46b20f47d096b0b27487b
fcd3d819cb3d2c2d043ccdbaeafe6d8938c3ac1d
c067414bc17bc7d65dd036f56b81b522265ba79f
42b39f38a9951c205df9d16bcece4422764f1cfd
530783a50d36aea82628de2abb90920c3428918d
831513e57eddad8652ae3addae987287a0047367
198365e19ea223bd73ee27faa555ca24ac6ed65d
76b3343a8cd2b25ff65dd493ea2bc18edea77be8
1ff89bb136025233f089fa48708d7d217db70895
0648939eac93a33ae5a9d6c4f5703f0baa2e68f3
8b9244eba18e07f3ad9d5eed4f972aa98f0c495e
63e81aabb8e9e45cc756c347e8cdfd9ae7c796ad
'

if [ ! -e "tsschecker" ]; then
    echo "Please put tsschecker."
    exit
fi

if [ $# -lt 5 ]; then
    echo "./getshsh.sh <ios> <device model> <boardconfig> <ecid> <save-path>"
    echo ""
    echo "[OPTION]"
    echo "-q        : quick mode (This flag is optional)"
    echo "./getshsh.sh <ios> <device model> <boardconfig> <ecid> <save-path> -q"
    echo ""
    exit
else

    if [ $# == 6 ]; then
        if [ "$6" = "-q" ]; then
            echo "** Quick Mode"
            echo "** NonceList"
            for nonce in ${ApNonce}
                do
                    echo "ApNonce: "$nonce""
                    ./tsschecker -i $1 —d $2 --boardconfig $3 -e $4 --save-path $5 -s --apnonce $nonce 2>/dev/null >/dev/null &
                done
            echo ""
        else
            echo "Invalid flag"
        exit
        fi

    else
        echo "** NonceList"
        for nonce in ${ApNonce}
            do
                echo "ApNonce: "$nonce""
                ./tsschecker -i $1 —d $2 --boardconfig $3 -e $4 --save-path $5 -s --apnonce $nonce 2>/dev/null >/dev/null
            done
        echo ""

    fi

## Stopper ##
echo "ApNonce: 05fe405753166f125559e7c9ac558654f107c7e9 (=0x0000000000000000 SHA1)"
./tsschecker -i $1 —d $2 --boardconfig $3 -e $4 --save-path $5 -s --apnonce 05fe405753166f125559e7c9ac558654f107c7e9



fi
