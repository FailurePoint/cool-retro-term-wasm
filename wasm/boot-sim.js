// Boot simulation: replays the output of pixel.sh (BIOS POST -> kernel ->
// mounts -> services -> getty -> login banner) into the terminal pipe,
// respecting the script's sleep() timings.
(function () {
  const L = window.crt;

  // [delay-ms, text] — mirrors the echo/sleep pairs in pixel.sh.
  const script = [
    [0,    "Initializing ROM BIOS v4.51 PG...\n"],
    [1000, "CPU: Intel Pentium III (Coppermine) @ 800MHz\n"],
    [500,  "Memory Test: 524288K OK\n"],
    [1000, "\n"],
    [0,    "Loading system kernel...\n"],
    [2000, "[    0.000000] Linux version 2.4.20-8custom (root@matrix) (gcc version 3.2.2)\n"],
    [1000, "[    0.142010] Initializing cgroup subsys cpuset\n"],
    [500,  "[    0.301948] Zone-based allocation completed.\n"],
    [1000, "[    0.852102] PCI: Probing PCI hardware\n"],
    [1500, "[    1.204599] SCSI subsystem initialized\n"],
    [1000, "\n"],
    [0,    "Mounting local filesystems...\n"],
    [2000, "/dev/hda1 on / type ext3 (rw)\n"],
    [500,  "/proc on /proc type proc (rw)\n"],
    [500,  "/sys on /sys type sysfs (rw)\n"],
    [1000, "\n"],
    [0,    "Starting system services:\n"],
    [0,    " - udevd: [ OK ]\n"],
    [500,  " - network interface (eth0): [ OK ]\n"],
    [1000, " - portmap: [ OK ]\n"],
    [500,  " - syslogd: [ OK ]\n"],
    [500,  " - sshd: [ OK ]\n"],
    [1000, "\n"],
    [0,    "Clearing temporary files...\n"],
    [1000, "Spawning getty on tty1...\n"],
    [1000, "\x1b[2J\x1b[H"],          // clear
    [0,    "\nUNIX System V Release 4.2MP (matrix)\n" +
           "kernel 2.4.20-8custom on an i686\n\n\n"],
    [0,    "______ _      _____ _     _____ _____ \n" +
           "| ___ \\ |    |____ | |   |  _  /  ___|\n" +
           "| |_/ / |_  __   / / |   | | | \\ `--. \n" +
           "|  __/| \\ \\/ /   \\ \\ |   | | | |`--. \\\n" +
           "| |   | |>  <.___/ / |   \\ \\_/ /\\__/ /\n" +
           "\\_|   | /_/\\_\\____/|_|    \\___/\\____/ \n" +
           "      | |                             \n" +
           "      |_|                             \n\n"],
    [0,    "dsm@Th3Pix3lB0x:~$ "]
  ];

  window.startBootSim = function () {
    let i = 0;
    function next () {
      if (i >= script.length) return;
      const [d, text] = script[i++];
      setTimeout(() => { L.write(text); next(); }, d);
    }
    next();
  };
})();
