#!/usr/bin/env python3
import argparse
import hashlib
import os
import subprocess

ITERATIONS = 200_000


def hash_password(password: str, salt: bytes | None = None) -> str:
    salt = salt or os.urandom(16)
    dk = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt, ITERATIONS)
    return f"pbkdf2_sha256${ITERATIONS}${salt.hex()}${dk.hex()}"


def main() -> None:
    parser = argparse.ArgumentParser(description="Actualiza password_hash en credentials")
    parser.add_argument("email", help="Email asociado a la credencial")
    parser.add_argument("password", help="Password plano")
    args = parser.parse_args()

    hash_value = hash_password(args.password)

    sql = (
        "USE GradesDB; UPDATE credentials SET password_hash='{hash}' WHERE email='{email}';".format(
            hash=hash_value, email=args.email
        )
    )

    result = subprocess.run(
        ["mariadb", "-e", sql],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        print("Error ejecutando mariadb:")
        print(result.stderr.strip())
    else:
        print(result.stdout.strip() or "Password actualizado")


if __name__ == "__main__":
    main()
