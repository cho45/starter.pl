#!/bin/sh
exec 2>&1
exec setuidgid apache multilog t ./main

