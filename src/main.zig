const std = @import("std");
const testing = std.testing;

fn printArray(x: []i32) void {
    std.debug.print("[", .{});
    defer std.debug.print("]\n", .{});

    std.debug.print("{d}", .{x[0]});
    var i: usize = 1;
    while (i < x.len) : (i += 1) {
        std.debug.print(", {d}", .{x[i]});
    }
}

test "print array" {
    var arr = [10]i32{ 4, 1, 3, 2, 16, 9, 10, 14, 8, 7 };
    std.debug.print("\n", .{});
    std.debug.print("  arr = ", .{});
    printArray(&arr);

    try testing.expect(@TypeOf(arr) == [10]i32);
    try testing.expect(@TypeOf(&arr) == *[10]i32);
}

fn heapParent(x: usize) usize {
    return (x - 1) >> 1;
}

fn heapLeft(x: usize) usize {
    return 1 + (x <<| 1);
}

fn heapRight(x: usize) usize {
    return (1 + x) <<| 1;
}

test "heap indices" {
    try testing.expect(heapParent(1) == 0);
    try testing.expect(heapParent(2) == 0);
    try testing.expect(heapParent(5) == 2);
    try testing.expect(heapParent(6) == 2);
    try testing.expect(heapLeft(1) == 3);
    try testing.expect(heapRight(2) == 6);
}

fn swap(arr: []i32, i: usize, j: usize) void {
    const tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}

// Assume that the binary trees rooted at
// heapLeft(ind) and heapRight(ind) are max-heaps.
fn maxHeapify(heap: []i32, ind: usize, heap_size: usize) void {
    var ix: usize = ind; // trial index
    var lx: usize = heapLeft(ix);
    var rx: usize = heapRight(ix);
    var tx: usize = undefined; // target index
    while (true) {
        tx = if (lx < heap_size and heap[lx] > heap[ix]) lx else ix;
        if (rx < heap_size and heap[rx] > heap[tx]) tx = rx;
        if (tx != ix) {
            swap(heap, ix, tx);
            ix = tx;
            lx = heapLeft(ix);
            rx = heapRight(ix);
        } else break;
    }
}

fn buildMaxHeap(heap: []i32, heap_size: usize) void {
    var ix: usize = heapParent(heap_size - 1); // parent of the last-one index
    while (ix > 0) : (ix -= 1) maxHeapify(heap, ix, heap_size);
    maxHeapify(heap, ix, heap_size);
}

fn heapSort(heap: []i32) void {
    var heap_size: usize = heap.len;
    var ix: usize = heap.len - 1;

    buildMaxHeap(heap, heap_size);

    while (ix > 0) : (ix -= 1) {
        swap(heap, 0, ix);
        heap_size -= 1;
        maxHeapify(heap, 0, heap_size);
    }
}

test "heapSort" {
    var arr = [10]i32{ 4, 1, 3, 2, 16, 9, 10, 14, 8, 7 };
    std.debug.print("\n", .{});
    std.debug.print("  init. arr = ", .{});
    printArray(&arr);
    heapSort(&arr);
    std.debug.print("  sort. arr = ", .{});
    printArray(&arr);

    try testing.expect(@TypeOf(arr) == [10]i32);
    try testing.expect(@TypeOf(&arr) == *[10]i32);
}
