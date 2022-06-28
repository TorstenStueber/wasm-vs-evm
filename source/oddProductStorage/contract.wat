(module
  (import "env" "memory" (memory $mimport$0 2 16))
  (import "seal0" "seal_input" (func $input (param i32 i32)))
  (import "seal0" "seal_return" (func $return (param i32 i32 i32)))
  (import "seal1" "seal_set_storage" (func $set_storage (param i32 i32 i32) (result i32)))
  (import "seal0" "seal_get_storage" (func $get_storage (param i32 i32 i32) (result i32)))
  (export "deploy" (func $deploy))
  (export "call" (func $call))
  (func $deploy)
  (func $call
    (local $prod i64)
    (local $doubleCounter i64)
    (local $counter i64)
    (local $writeFreq i64)

    (i32.store (i32.const 0) (i32.const 100))
    (call $input (i32.const 8) (i32.const 0))

    (local.set $doubleCounter 
      (i64.add 
        (i64.const 1) 
        (i64.shl (i64.load32_u (i32.const 12)) (i64.const 1))
      )
    )

    (local.set $counter (i64.load32_u (i32.const 12)))
    
    (local.set $writeFreq (i64.load (i32.const 16)))

    (drop (call $set_storage (i32.const 1000) (i32.const 1200) (i32.const 8)))

    (local.set $prod (i64.const 1))
    (loop
      (if 
        (i64.eqz
          (i64.rem_u 
            (local.tee $counter (i64.sub (local.get $counter) (i64.const 1))) 
            (local.get $writeFreq)
          )
        )
        (then
          (drop (call $get_storage (i32.const 1000) (i32.const 1200) (i32.const 8)))
        )
        (else)
      )

      (local.set $prod 
        (i64.mul 
          (local.get $prod)
          (local.tee $doubleCounter (i64.sub (local.get $doubleCounter) (i64.const 2)))
        )
      )

      (br_if 0 (i64.ne (local.get $doubleCounter) (i64.const 1)))
    )

    (i64.store (i32.const 12) (local.get $prod))
    (call $return (i32.const 0) (i32.const 12) (i32.const 8))
  )
)

