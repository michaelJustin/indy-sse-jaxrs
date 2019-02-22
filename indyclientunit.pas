unit IndyClientUnit;

{$mode delphi}

interface

uses
  Classes, SysUtils;

procedure RunTest;

implementation

uses
  IdHTTP;

procedure RunTest;
var
  IdHTTP: TIdHTTP;
  Response: string;
begin
  IdHTTP := TIdHTTP.Create;
  try
    IdHTTP.HTTPOptions := IdHTTP.HTTPOptions
      + [hoNoProtocolErrorException, hoWantProtocolErrorContent];
    try
      Response := IdHTTP.Get('http://localhost:8080/indy-sse-jaxrs/api/generic/prices');

      WriteLn(Response);
    except
      on E: Exception do begin
        WriteLn(E.Message);
      end;
    end;
  finally
    IdHTTP.Free;
  end;

  WriteLn('Hit any key ...');
  ReadLn;


end;

end.

