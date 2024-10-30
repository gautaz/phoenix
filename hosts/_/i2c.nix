_: {
  # I2C is for now only needed by ddcutil
  boot.kernelModules = ["i2c-dev"];
  hardware.i2c.enable = true;
  users.users.del.extraGroups = ["i2c"];
}
