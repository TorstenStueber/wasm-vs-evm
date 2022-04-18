;; code based on TweetNacl-WebAssembly
;; see https://github.com/TorstenStueber/TweetNacl-WebAssembly

(module
  (import "env" "memory" (memory $mimport$0 2 16))
  (import "seal0" "seal_input" (func $input (param i32 i32)))
  (import "seal0" "seal_return" (func $return (param i32 i32 i32)))
  (export "deploy" (func $deploy))
  (export "call" (func $call))

  (data (i32.const 0x400) "\22\ae\28\d7\98\2f\8a\42\cd\65\ef\23\91\44\37\71\2f\3b\4d\ec\cf\fb\c0\b5\bc\db\89\81\a5\db\b5\e9\38\b5\48\f3\5b\c2\56\39\19\d0\05\b6\f1\11\f1\59\9b\4f\19\af\a4\82\3f\92\18\81\6d\da\d5\5e\1c\ab\42\02\03\a3\98\aa\07\d8\be\6f\70\45\01\5b\83\12\8c\b2\e4\4e\be\85\31\24\e2\b4\ff\d5\c3\7d\0c\55\6f\89\7b\f2\74\5d\be\72\b1\96\16\3b\fe\b1\de\80\35\12\c7\25\a7\06\dc\9b\94\26\69\cf\74\f1\9b\c1\d2\4a\f1\9e\c1\69\9b\e4\e3\25\4f\38\86\47\be\ef\b5\d5\8c\8b\c6\9d\c1\0f\65\9c\ac\77\cc\a1\0c\24\75\02\2b\59\6f\2c\e9\2d\83\e4\a6\6e\aa\84\74\4a\d4\fb\41\bd\dc\a9\b0\5c\b5\53\11\83\da\88\f9\76\ab\df\66\ee\52\51\3e\98\10\32\b4\2d\6d\c6\31\a8\3f\21\fb\98\c8\27\03\b0\e4\0e\ef\be\c7\7f\59\bf\c2\8f\a8\3d\f3\0b\e0\c6\25\a7\0a\93\47\91\a7\d5\6f\82\03\e0\51\63\ca\06\70\6e\0e\0a\67\29\29\14\fc\2f\d2\46\85\0a\b7\27\26\c9\26\5c\38\21\1b\2e\ed\2a\c4\5a\fc\6d\2c\4d\df\b3\95\9d\13\0d\38\53\de\63\af\8b\54\73\0a\65\a8\b2\77\3c\bb\0a\6a\76\e6\ae\ed\47\2e\c9\c2\81\3b\35\82\14\85\2c\72\92\64\03\f1\4c\a1\e8\bf\a2\01\30\42\bc\4b\66\1a\a8\91\97\f8\d0\70\8b\4b\c2\30\be\54\06\a3\51\6c\c7\18\52\ef\d6\19\e8\92\d1\10\a9\65\55\24\06\99\d6\2a\20\71\57\85\35\0e\f4\b8\d1\bb\32\70\a0\6a\10\c8\d0\d2\b8\16\c1\a4\19\53\ab\41\51\08\6c\37\1e\99\eb\8e\df\4c\77\48\27\a8\48\9b\e1\b5\bc\b0\34\63\5a\c9\c5\b3\0c\1c\39\cb\8a\41\e3\4a\aa\d8\4e\73\e3\63\77\4f\ca\9c\5b\a3\b8\b2\d6\f3\6f\2e\68\fc\b2\ef\5d\ee\82\8f\74\60\2f\17\43\6f\63\a5\78\72\ab\f0\a1\14\78\c8\84\ec\39\64\1a\08\02\c7\8c\28\1e\63\23\fa\ff\be\90\e9\bd\82\de\eb\6c\50\a4\15\79\c6\b2\f7\a3\f9\be\2b\53\72\e3\f2\78\71\c6\9c\61\26\ea\ce\3e\27\ca\07\c2\c0\21\c7\b8\86\d1\1e\eb\e0\cd\d6\7d\da\ea\78\d1\6e\ee\7f\4f\7d\f5\ba\6f\17\72\aa\67\f0\06\a6\98\c8\a2\c5\7d\63\0a\ae\0d\f9\be\04\98\3f\11\1b\47\1c\13\35\0b\71\1b\84\7d\04\23\f5\77\db\28\93\24\c7\40\7b\ab\ca\32\bc\be\c9\15\0a\be\9e\3c\4c\0d\10\9c\c4\67\1d\43\b6\42\3e\cb\be\d4\c5\4c\2a\7e\65\fc\9c\29\7f\59\ec\fa\d6\3a\ab\6f\cb\5f\17\58\47\4a\8c\19\44\6c")
  (global $K i32 (i32.const 0x400)) ;; pointer to 640 bytes

  (global $globalsEnd i32 (i32.const 0x7b0))

  (func $deploy)
  (func $call
    (local $start i32)
    (local $counter i32)

    (i32.store (i32.const 0) (i32.const 100))
    (call $input (i32.const 8) (i32.const 0))

    (local.set $start (i32.load (i32.const 12)))
    (local.set $counter (i32.load (i32.const 16)))

    (i32.store8 (i32.const 2032) (local.get $start)) ;; 0x7b0 + 64


    (i32.const 1968)
    (i32.const 2032)
    (i32.const 1)
    (i32.const 2040) ;; 2032 + 8
    (call $crypto_hash)

    (loop
      (i64.store (i32.const 2032) (i64.load (i32.const 1968)))
      (i64.store (i32.const 2040) (i64.load (i32.const 1976)))
      (i64.store (i32.const 2048) (i64.load (i32.const 1984)))
      (i64.store (i32.const 2056) (i64.load (i32.const 1992)))
      (i64.store (i32.const 2064) (i64.load (i32.const 2000)))
      (i64.store (i32.const 2072) (i64.load (i32.const 2008)))
      (i64.store (i32.const 2080) (i64.load (i32.const 2016)))
      (i64.store (i32.const 2088) (i64.load (i32.const 2024)))

      (i32.const 1968)
      (i32.const 2032)
      (i32.const 64)
      (i32.const 2096) ;; 2032 + 64
      (call $crypto_hash)

      (br_if 0 (i32.ne (local.tee $counter (i32.sub (local.get $counter) (i32.const 1))) (i32.const -1)))
    )

    (call $return (i32.const 0) (i32.const 0x7b0) (i32.const 8))
  )


  ;; Author: Torsten Stüber

  ;; output pointer $out: 64 bytes
  ;; input pointer $m: $n bytes
  ;; input value $n
  ;; alloc pointer $alloc: 128 + 256 = 384 bytes
  (func $crypto_hash
    (param $out i32)
    (param $m i32)
    (param $n i32)
    (param $alloc i32)

    (local $x i32)
    (local $i i32)
    (local $tmp i32)
    (local $a i64)

    (local.set $x (i32.add (i32.const 128) (local.get $alloc)))

    (i64.store offset=0  (local.get $out) (i64.const 0x6a09e667f3bcc908))
    (i64.store offset=8  (local.get $out) (i64.const 0xbb67ae8584caa73b))
    (i64.store offset=16 (local.get $out) (i64.const 0x3c6ef372fe94f82b))
    (i64.store offset=24 (local.get $out) (i64.const 0xa54ff53a5f1d36f1))
    (i64.store offset=32 (local.get $out) (i64.const 0x510e527fade682d1))
    (i64.store offset=40 (local.get $out) (i64.const 0x9b05688c2b3e6c1f))
    (i64.store offset=48 (local.get $out) (i64.const 0x1f83d9abfb41bd6b))
    (i64.store offset=56 (local.get $out) (i64.const 0x5be0cd19137e2179))

    (local.get $out)
    (local.get $m)
    (local.get $n)
    (local.get $alloc)
    (call $crypto_hashblocks)

    (local.get $n)
      (local.set $m (i32.add (local.get $m) (local.get $n)))
      (local.set $n (i32.and (local.get $n) (i32.const 127)))
      (local.set $m (i32.sub (local.get $m) (local.get $n)))

      (local.set $tmp (local.get $x))
      (block
        (loop
          (br_if 1 (i32.eq (local.get $i) (local.get $n)))

          (i32.store8 (local.get $tmp) (i32.load8_u (local.get $m)))

          (local.set $i (i32.add (i32.const 1) (local.get $i)))
          (local.set $tmp (i32.add (i32.const 1) (local.get $tmp)))
          (local.set $m (i32.add (i32.const 1) (local.get $m)))
          (br 0)
        )
      )
    
      (i32.store8 (local.get $tmp) (i32.const 128))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (block
        (loop
          (br_if 1 (i32.eq (local.get $i) (i32.const 256)))

          (i32.store8 offset=1 (local.get $tmp) (i32.const 0))

          (local.set $i (i32.add (i32.const 1) (local.get $i)))
          (local.set $tmp (i32.add (i32.const 1) (local.get $tmp)))
          (br 0)
        )
      )
      
    (local.set $tmp)

    (local.set $n (select (i32.const 128) (i32.const 256) (i32.lt_u (local.get $n) (i32.const 112))))

    (local.get $out)
    (local.get $x)
    (local.get $n)
    (local.get $alloc)
      (local.set $x (i32.sub (i32.add (local.get $x) (local.get $n)) (i32.const 9)))
      (i32.store8 (local.get $x) (i32.const 0))
      (i32.store8 offset=1 (local.get $x) (i32.const 0))
      (i32.store8 offset=2 (local.get $x) (i32.const 0))
      (i32.store8 offset=3 (local.get $x) (i32.const 0))
      (i32.store8 offset=4 (local.get $x) (i32.shr_u (local.get $tmp) (i32.const 29)))
      (i32.store8 offset=5 (local.get $x) (i32.shr_u (local.get $tmp) (i32.const 21)))
      (i32.store8 offset=6 (local.get $x) (i32.shr_u (local.get $tmp) (i32.const 13)))
      (i32.store8 offset=7 (local.get $x) (i32.shr_u (local.get $tmp) (i32.const 5)))
      (i32.store8 offset=8 (local.get $x) (i32.shl (local.get $tmp) (i32.const 3)))
    (call $crypto_hashblocks)

    (local.set $a (i64.load offset=0 (local.get $out)))
    (i64.store8 offset=0 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=1 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=2 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=3 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=4 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=5 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=6 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=7 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=8 (local.get $out)))
    (i64.store8 offset=8 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=9 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=10 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=11 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=12 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=13 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=14 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=15 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=16 (local.get $out)))
    (i64.store8 offset=16 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=17 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=18 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=19 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=20 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=21 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=22 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=23 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=24 (local.get $out)))
    (i64.store8 offset=24 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=25 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=26 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=27 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=28 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=29 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=30 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=31 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=32 (local.get $out)))
    (i64.store8 offset=32 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=33 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=34 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=35 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=36 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=37 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=38 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=39 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=40 (local.get $out)))
    (i64.store8 offset=40 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=41 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=42 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=43 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=44 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=45 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=46 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=47 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=48 (local.get $out)))
    (i64.store8 offset=48 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=49 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=50 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=51 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=52 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=53 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=54 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=55 (local.get $out) (local.get $a))

    (local.set $a (i64.load offset=56 (local.get $out)))
    (i64.store8 offset=56 (local.get $out) (i64.shr_u (local.get $a) (i64.const 56)))
    (i64.store8 offset=57 (local.get $out) (i64.shr_u (local.get $a) (i64.const 48)))
    (i64.store8 offset=58 (local.get $out) (i64.shr_u (local.get $a) (i64.const 40)))
    (i64.store8 offset=59 (local.get $out) (i64.shr_u (local.get $a) (i64.const 32)))
    (i64.store8 offset=60 (local.get $out) (i64.shr_u (local.get $a) (i64.const 24)))
    (i64.store8 offset=61 (local.get $out) (i64.shr_u (local.get $a) (i64.const 16)))
    (i64.store8 offset=62 (local.get $out) (i64.shr_u (local.get $a) (i64.const 8)))
    (i64.store8 offset=63 (local.get $out) (local.get $a))
  )



  ;; Author: Torsten Stüber

  ;; input/output pointer $h: 64 bytes; 8 x 64 bit numbers (stored little endian, not big endian as in original tweetnacl)
  ;; input pointer $m: $n bytes
  ;; input value $n
  ;; alloc pointer $alloc: 128 bytes
  (func $crypto_hashblocks
    (param $h i32)
    (param $m i32)
    (param $n i32)
    (param $alloc i32)

    (local $b0 i64) (local $b1 i64) (local $b2 i64) (local $b3 i64)
    (local $b4 i64) (local $b5 i64) (local $b6 i64) (local $b7 i64)
    (local $a0 i64) (local $a1 i64) (local $a2 i64) (local $a3 i64)
    (local $a4 i64) (local $a5 i64) (local $a6 i64) (local $a7 i64)
    (local $t i64)
    (local $tmp1 i64) (local $tmp2 i64) (local $tmp3 i64)
    (local $w i32) (local $i i32) (local $j i32) (local $k i32) (local $K i32)

    (local.set $w (local.get $alloc))
    
    (local.set $a0 (i64.load offset=0 (local.get $h)))
    (local.set $a1 (i64.load offset=8 (local.get $h)))
    (local.set $a2 (i64.load offset=16 (local.get $h)))
    (local.set $a3 (i64.load offset=24 (local.get $h)))
    (local.set $a4 (i64.load offset=32 (local.get $h)))
    (local.set $a5 (i64.load offset=40 (local.get $h)))
    (local.set $a6 (i64.load offset=48 (local.get $h)))
    (local.set $a7 (i64.load offset=56 (local.get $h)))

    (block
      (loop
        (br_if 1(i32.lt_u (local.get $n) (i32.const 128)))

        (local.set $i (i32.const 0))
        (local.set $j (local.get $m))
        (local.set $k (local.get $w))
        (block
          (loop
            (br_if 1 (i32.eq (local.get $i) (i32.const 16)))

            (i64.store (local.get $k) (i64.or
              (i64.or
                (i64.or
                  (i64.shl (i64.load8_u offset=0 (local.get $j)) (i64.const 56))
                  (i64.shl (i64.load8_u offset=1 (local.get $j)) (i64.const 48))
                )
                (i64.or
                  (i64.shl (i64.load8_u offset=2 (local.get $j)) (i64.const 40))
                  (i64.shl (i64.load8_u offset=3 (local.get $j)) (i64.const 32))
                )
              )
              (i64.or
                (i64.or
                  (i64.shl (i64.load8_u offset=4 (local.get $j)) (i64.const 24))
                  (i64.shl (i64.load8_u offset=5 (local.get $j)) (i64.const 16))
                )
                (i64.or 
                  (i64.shl (i64.load8_u offset=6 (local.get $j)) (i64.const 8))
                  (i64.load8_u offset=7 (local.get $j))
                )
              )
            ))

            (local.set $i (i32.add (i32.const 1) (local.get $i)))
            (local.set $j (i32.add (i32.const 8) (local.get $j)))
            (local.set $k (i32.add (i32.const 8) (local.get $k)))
            (br 0)
          )
        )

        (local.set $i (i32.const 0))
        (local.set $K (global.get $K))
        (block
          (loop
            (br_if 1 (i32.eq (local.get $i) (i32.const 80)))

            (local.set $b0 (local.get $a0))
            (local.set $b1 (local.get $a1))
            (local.set $b2 (local.get $a2))
            (local.set $b3 (local.get $a3))
            (local.set $b4 (local.get $a4))
            (local.set $b5 (local.get $a5))
            (local.set $b6 (local.get $a6))
            (local.set $b7 (local.get $a7))

            (local.set $t (i64.add
              (i64.add
                (local.get $a7)
                (i64.xor 
                  (i64.xor
                    (i64.rotr (local.get $a4) (i64.const 14))
                    (i64.rotr (local.get $a4) (i64.const 18))
                  )
                  (i64.rotr (local.get $a4) (i64.const 41))
                )
              )
              (i64.add
                (i64.xor 
                  (i64.and (local.get $a4) (local.get $a5))
                  (i64.and (i64.xor (local.get $a4) (i64.const -1)) (local.get $a6))
                )
                (i64.add
                  (i64.load (local.get $K))
                  (i64.load (i32.add (local.get $w) (i32.shl (i32.and (local.get $i) (i32.const 0xf)) (i32.const 3))))
                )
              )
            ))

            (local.set $b7 (i64.add
              (i64.add
                (local.get $t)
                (i64.xor 
                  (i64.xor
                    (i64.rotr (local.get $a0) (i64.const 28))
                    (i64.rotr (local.get $a0) (i64.const 34))
                  )
                  (i64.rotr (local.get $a0) (i64.const 39))
                )
              )
              (i64.xor 
                (i64.xor
                  (i64.and (local.get $a0) (local.get $a1))
                  (i64.and (local.get $a0) (local.get $a2))
                )
                (i64.and (local.get $a1) (local.get $a2))
              )
            ))

            (local.set $b3 (i64.add (local.get $b3) (local.get $t)))

            (local.set $a1 (local.get $b0))
            (local.set $a2 (local.get $b1))
            (local.set $a3 (local.get $b2))
            (local.set $a4 (local.get $b3))
            (local.set $a5 (local.get $b4))
            (local.set $a6 (local.get $b5))
            (local.set $a7 (local.get $b6))
            (local.set $a0 (local.get $b7))

            (if (i32.eq (i32.and (local.get $i) (i32.const 0xf)) (i32.const 15))
              (then

                (local.set $tmp1 (i64.load offset=72 (local.get $w)))
                (local.set $tmp2 (i64.load offset=8 (local.get $w)))
                (local.set $tmp3 (i64.load offset=112 (local.get $w)))
                (i64.store offset=0 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=0 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=80 (local.get $w)))
                (local.set $tmp2 (i64.load offset=16 (local.get $w)))
                (local.set $tmp3 (i64.load offset=120 (local.get $w)))
                (i64.store offset=8 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=8 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=88 (local.get $w)))
                (local.set $tmp2 (i64.load offset=24 (local.get $w)))
                (local.set $tmp3 (i64.load offset=0 (local.get $w)))
                (i64.store offset=16 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=16 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=96 (local.get $w)))
                (local.set $tmp2 (i64.load offset=32 (local.get $w)))
                (local.set $tmp3 (i64.load offset=8 (local.get $w)))
                (i64.store offset=24 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=24 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=104 (local.get $w)))
                (local.set $tmp2 (i64.load offset=40 (local.get $w)))
                (local.set $tmp3 (i64.load offset=16 (local.get $w)))
                (i64.store offset=32 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=32 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=112 (local.get $w)))
                (local.set $tmp2 (i64.load offset=48 (local.get $w)))
                (local.set $tmp3 (i64.load offset=24 (local.get $w)))
                (i64.store offset=40 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=40 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=120 (local.get $w)))
                (local.set $tmp2 (i64.load offset=56 (local.get $w)))
                (local.set $tmp3 (i64.load offset=32 (local.get $w)))
                (i64.store offset=48 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=48 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=0 (local.get $w)))
                (local.set $tmp2 (i64.load offset=64 (local.get $w)))
                (local.set $tmp3 (i64.load offset=40 (local.get $w)))
                (i64.store offset=56 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=56 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=8 (local.get $w)))
                (local.set $tmp2 (i64.load offset=72 (local.get $w)))
                (local.set $tmp3 (i64.load offset=48 (local.get $w)))
                (i64.store offset=64 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=64 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=16 (local.get $w)))
                (local.set $tmp2 (i64.load offset=80 (local.get $w)))
                (local.set $tmp3 (i64.load offset=56 (local.get $w)))
                (i64.store offset=72 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=72 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=24 (local.get $w)))
                (local.set $tmp2 (i64.load offset=88 (local.get $w)))
                (local.set $tmp3 (i64.load offset=64 (local.get $w)))
                (i64.store offset=80 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=80 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=32 (local.get $w)))
                (local.set $tmp2 (i64.load offset=96 (local.get $w)))
                (local.set $tmp3 (i64.load offset=72 (local.get $w)))
                (i64.store offset=88 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=88 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=40 (local.get $w)))
                (local.set $tmp2 (i64.load offset=104 (local.get $w)))
                (local.set $tmp3 (i64.load offset=80 (local.get $w)))
                (i64.store offset=96 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=96 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=48 (local.get $w)))
                (local.set $tmp2 (i64.load offset=112 (local.get $w)))
                (local.set $tmp3 (i64.load offset=88 (local.get $w)))
                (i64.store offset=104 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=104 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=56 (local.get $w)))
                (local.set $tmp2 (i64.load offset=120 (local.get $w)))
                (local.set $tmp3 (i64.load offset=96 (local.get $w)))
                (i64.store offset=112 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=112 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                (local.set $tmp1 (i64.load offset=64 (local.get $w)))
                (local.set $tmp2 (i64.load offset=0 (local.get $w)))
                (local.set $tmp3 (i64.load offset=104 (local.get $w)))
                (i64.store offset=120 (local.get $w) (i64.add
                  (i64.add
                    (i64.load offset=120 (local.get $w))
                    (local.get $tmp1)
                  )
                  (i64.add
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp2) (i64.const 1))
                        (i64.rotr (local.get $tmp2) (i64.const 8))
                      )
                      (i64.shr_u (local.get $tmp2) (i64.const 7))
                    )
                    (i64.xor
                      (i64.xor
                        (i64.rotr (local.get $tmp3) (i64.const 19))
                        (i64.rotr (local.get $tmp3) (i64.const 61))
                      )
                      (i64.shr_u (local.get $tmp3) (i64.const 6))
                    )
                  )
                ))

                

              )
            )

            (local.set $i (i32.add (i32.const 1) (local.get $i)))
            (local.set $K (i32.add (i32.const 8) (local.get $K)))
            (br 0)
          )
        )

        (i64.store offset=0 (local.get $h) (local.tee $a0 (i64.add
          (local.get $a0) (i64.load offset=0 (local.get $h))
        )))
        (i64.store offset=8 (local.get $h) (local.tee $a1 (i64.add
          (local.get $a1) (i64.load offset=8 (local.get $h))
        )))
        (i64.store offset=16 (local.get $h) (local.tee $a2 (i64.add
          (local.get $a2) (i64.load offset=16 (local.get $h))
        )))
        (i64.store offset=24 (local.get $h) (local.tee $a3 (i64.add
          (local.get $a3) (i64.load offset=24 (local.get $h))
        )))
        (i64.store offset=32 (local.get $h) (local.tee $a4 (i64.add
          (local.get $a4) (i64.load offset=32 (local.get $h))
        )))
        (i64.store offset=40 (local.get $h) (local.tee $a5 (i64.add
          (local.get $a5) (i64.load offset=40 (local.get $h))
        )))
        (i64.store offset=48 (local.get $h) (local.tee $a6 (i64.add
          (local.get $a6) (i64.load offset=48 (local.get $h))
        )))
        (i64.store offset=56 (local.get $h) (local.tee $a7 (i64.add
          (local.get $a7) (i64.load offset=56 (local.get $h))
        )))

        (local.set $m (i32.add (i32.const 128) (local.get $m)))
        (local.set $n (i32.sub (local.get $n) (i32.const 128)))
        (br 0)
      )
    )
  )
)

