#![feature(lang_items)]
#![no_std]

extern crate libc;

use libc::{c_char, c_int};
use core::panic::PanicInfo;

extern "C" {
    #[no_mangle]
    fn abs(input: i32) -> i32;

    #[no_mangle]
    fn printf(fmt: *const c_char, ...) -> c_int;
}

fn main() {
    unsafe {
        printf("Hello World! (from Rust main())\n\0".as_ptr() as *const i8);
    }
    loop{}
}

/// This function is called on panic.
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] #[no_mangle] pub extern fn panic_fmt() -> ! {loop{}}

