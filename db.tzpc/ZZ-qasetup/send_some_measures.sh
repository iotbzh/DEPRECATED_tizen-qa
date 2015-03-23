#!/bin/bash


echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"
echo "Test bla bla"

cat /etc/passwd

echo "###[NOTE]###This test should contain some measures !"

echo "###[MEASURE]###power:150:mW"

echo "###[MEASURE]###not_visible:0:A" >&2

echo "###[MEASURE]###:bad:measure:coz:no:name"

echo "###[MEASURE]###speed:55:Knots:60:40"

echo "test tordu avec des caracteres avant la pattern#####[MEASURE]###foo:300:GV"

echo "Success" >&2

exit 0
