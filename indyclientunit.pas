unit IndyClientUnit;

{$mode delphi}

interface

procedure RunTest;

implementation

// see https://www.indyproject.org/2016/01/10/new-tidhttp-flags-and-onchunkreceived-event/

uses
  IdHTTP, IdGlobal, SysUtils;

const
  SSE_URL = 'http://localhost:8080/indy-sse-jaxrs/api/generic/prices';

type
  TIndySSEClient = class(TObject)
  private
    IdHTTP: TIdHTTP;
    ChunkCount: Integer;
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
    try
      Client.Run;
    except
      on E: Exception do
        WriteLn(E.Message);
    end;
  finally
    Client.Free;
  end;
end;

{ TIndySSEClient }

constructor TIndySSEClient.Create;
begin
  inherited;

  IdHTTP := TIdHTTP.Create;
  IdHTTP.OnChunkReceived := MyChunkReceived;

  WriteLn(SSE_URL);
end;

destructor TIndySSEClient.Destroy;
begin
  IdHTTP.Free;

  inherited;
end;

procedure TIndySSEClient.Run;
begin
  IdHTTP.Get(SSE_URL {, Stream});
end;

procedure TIndySSEClient.MyChunkReceived(Sender: TObject; var Chunk: TIdBytes);
begin
  WriteLn(IndyTextEncoding_UTF8.GetString(Chunk));

  Inc(ChunkCount);
  if ChunkCount > 2 then begin
    WriteLn('Closing connection');
    IdHTTP.Disconnect;
  end;
end;

end.

