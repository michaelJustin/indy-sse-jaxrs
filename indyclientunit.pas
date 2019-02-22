unit IndyClientUnit;

{$mode delphi}

interface

procedure RunTest;

implementation

uses
  IdHTTP, IdGlobal, SysUtils;

type

  { TIndySSEClient }

  TIndySSEClient = class(TObject)
  private
    IdHTTP: TIdHTTP;
  protected
    procedure MyChunkReceived(Sender : TObject; var Chunk: TIdBytes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
  end;

procedure RunTest;
var
  Client: TIndySSEClient;
begin
  Client := TIndySSEClient.Create;
  try
    Client.Run;
  finally
    Client.Free;
  end;
end;

{ TIndySSEClient }

constructor TIndySSEClient.Create;
begin
  inherited;

  IdHTTP := TIdHTTP.Create;
  IdHTTP.HTTPOptions := IdHTTP.HTTPOptions
    + [hoNoProtocolErrorException, hoWantProtocolErrorContent];
  IdHTTP.OnChunkReceived := MyChunkReceived;
end;

destructor TIndySSEClient.Destroy;
begin
  inherited;

  IdHTTP.Free;
end;

procedure TIndySSEClient.Run;
var
  Stream: TIdEventStream;
begin
  Stream := TIdEventStream.Create;

  try
    IdHTTP.Get('http://localhost:8080/indy-sse-jaxrs/api/generic/prices', Stream);
  except
    on E: Exception do begin
      WriteLn(E.Message);
    end;
  end;
end;

procedure TIndySSEClient.MyChunkReceived(Sender: TObject; var Chunk: TIdBytes);
begin
  WriteLn(IndyTextEncoding_UTF8.GetString(Chunk));
end;

end.

