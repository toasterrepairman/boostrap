{
  pkgs
}:

pkgs.stdenv.mkDerivation rec {
  pname = "aruco";
  version = "3.1.15";

  src = pkgs.fetchFromGitHub {
    owner = "opentrack";
    repo = "aruco";
    rev = "1.3.1-source-20200326";
    hash = "sha256-xFMlcuABxsIL5sOr8s9g5hcDG7dPYnmHKGHRfTSbNhk=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs = with pkgs; [
    opencv4
  ];

  cmakeFlags = [
    "-DBUILD_UTILS=OFF"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_GLSAMPLES=OFF"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_DEBPACKAGE=OFF"
    "-DBUILD_SVM=OFF"
    "-DBUILD_UTILS=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta = with pkgs.lib; {
    description = "ArUco marker detection library";
    homepage = "https://github.com/opentrack/aruco";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
