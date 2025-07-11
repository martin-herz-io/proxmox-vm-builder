#!/bin/bash

generate_passwords() {
  ROOTPASS=$(openssl rand -base64 12)
  USERPASS=$(openssl rand -base64 12)
}
