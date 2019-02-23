program IndySseClient;

uses
  LazUTF8,
  IndyClientUnit;

begin
  RunTest('http://localhost:8080/indy-sse-jaxrs/api/generic/prices');
  WriteLn('Hit any key ...');
  ReadLn;
end.

