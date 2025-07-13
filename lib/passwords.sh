#!/bin/bash

generate_passwords() {
  ROOTPASS=$(openssl rand -base64 24)
  USERPASS=$(openssl rand -base64 24)
}
