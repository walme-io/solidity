{
    function allocate(size) -> p {
        p := mload(0x40)
        mstore(0x40, add(p, size))
    }
    function array_index_access(array, index) -> p {
        p := add(array, mul(index, 0x20))
    }
    pop(allocate(0x20))
    let x := allocate(0x40)
    mstore(array_index_access(x, 3), 2)
    if 0 {
        mstore(0x40, 0x20)
    }
    mstore(0x40, 0x20)
    sstore(0, array_index_access(x, 3))
    sstore(1, mload(0x40))
}
// ----
// step: fullSuite
//
// {
//     {
//         mstore(0x40, add(mload(0x40), 0x20))
//         let p := mload(0x40)
//         mstore(0x40, add(p, 0x40))
//         let _1 := add(p, 96)
//         mstore(_1, 2)
//         mstore(0x40, 0x20)
//         sstore(0, _1)
//         sstore(1, mload(0x40))
//     }
// }
