cflags{
	'-D _GNU_SOURCE',
	'-D CONFIG_FS_NET',
	'-D CONFIG_RISCV_MAX_XLEN=64',
	'-D CONFIG_SLIRP',
	[[-D 'CONFIG_VERSION="2018-09-23"']],
	'-I $builddir/pkg/curl/include',
}

pkg.deps = {'pkg/curl/headers'}

build('cc', '$outdir/riscv_cpu32.o', '$srcdir/riscv_cpu.c', {cflags='$cflags -DMAX_XLEN=32'})
build('cc', '$outdir/riscv_cpu64.o', '$srcdir/riscv_cpu.c', {cflags='$cflags -DMAX_XLEN=64'})

exe('temu', [[
	virtio.c pci.c fs.c cutils.c iomem.c simplefb.c
	json.c machine.c temu.c
	slirp/(
		bootp.c ip_icmp.c mbuf.c slirp.c tcp_output.c cksum.c ip_input.c
		misc.c socket.c tcp_subr.c udp.c if.c ip_output.c sbuf.c
		tcp_input.c tcp_timer.c
	)
	fs_disk.c fs_net.c fs_wget.c fs_utils.c block_net.c
	riscv_machine.c softfp.c riscv_cpu32.o riscv_cpu64.o
	x86_cpu.c x86_machine.c ide.c ps2.c vmmouse.c pckbd.c vga.c
	$builddir/pkg/curl/libcurl.a.d
]])
file('bin/temu', '755', '$outdir/temu')

fetch 'curl'