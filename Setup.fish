cargo init $argv

mkdir -p .cargo/

# .cargo/config.toml
echo '''
[build]
target = "thumbv7em-none-eabihf"

[target.thumbv7em-none-eabihf]
runner = "probe-rs run --chip nRF52833_xxAA"
rustflags = [
  "-C", "linker=rust-lld",
  "-C", "link-arg=-Tlink.x",
]
''' > .cargo/config.toml

# Cargo.toml
cargo add \
    cortex-m-rt \
    embedded-hal \
    microbit-v2 \
    panic-halt \
    rtt-target \
    cortex-m --features cortex-m/critical-section-single-core

# Embed.toml
echo '''
[default.general]
chip = "nrf52833_xxAA"

[default.reset]
halt_afterwards = false

[default.rtt]
enabled = true

[default.gdb]
enabled = false
''' > Embed.toml

mkdir -p src/

echo '''
#![no_main]
#![no_std]

use cortex_m_rt::entry;
use embedded_hal::delay::DelayNs;
use microbit::{display::blocking::Display, hal::timer};
use panic_halt as _;
use rtt_target::{rprintln, rtt_init_print};

#[entry]
fn main() -> ! {
    rtt_init_print!();

    rprintln!("hello!");

    loop {

    }
}

''' > src/main.rs
