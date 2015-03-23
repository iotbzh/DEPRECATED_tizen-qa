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

echo "###[NOTE]###This note should be present in QA report"

echo "###[NOTE]###This note should NOT be present in QA report" >&2

#cat /etc/passwd >>$TESTCASE_NOTES
#echo "This note should also be readable" >$TESTCASE_NOTES

echo FOO BAR BAZ | sed 's/^/###[NOTE]###/g'  

echo "test tordu avec des caracteres avant la pattern#####[NOTE]###Everything works !"

echo "Success" >&2

exit 0
