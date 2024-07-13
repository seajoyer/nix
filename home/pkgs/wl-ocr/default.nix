{
  writeShellScriptBin,
  lib,
  grim,
  libnotify,
  slurp,
  tesseract,
  wl-clipboard,
  langs ? "eng+rus",
}:

let
  _ = lib.getExe;
in
  writeShellScriptBin "wl-ocr" ''
    ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract} -l ${langs} - - | ${wl-clipboard}/bin/wl-copy
    echo "$(${wl-clipboard}/bin/wl-paste)"
    ${_ libnotify} -- "$(${wl-clipboard}/bin/wl-paste)"
  ''
