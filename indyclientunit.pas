unit IndyClientUnit;

{$I IdCompilerDefines.inc}

interface

procedure RunTest(URL: string);

implementation

// see
// https://www.indyproject.org/2016/01/10/new-tidhttp-flags-and-onchunkreceived-event/
// https://www.html5rocks.com/en/tutorials/eventsource/basics/

uses
  IdHTTP, IdGlobal, SysUtils;

type

  { TIndySSEClient }

  TIndySSEClient = class(TObject)
  private
    EventStream: TIdEventStream;
    IdHTTP: TIdHTTP;
    ChunkCount: Integer;
    SSE_URL: string;
  protected
    procedure MyOnWrite(const ABuffer: TIdBytes; AOffset, ACount: Longint; var VResult: Longint);

  public
    constructor Create(const URL: string);
    destructor Destroy; override;

    procedure Run;
  end;

procedure RunTest;
var
  Client: TIndySSEClient;
begin
  WriteLn('URL for Server-sent events: ' + URL);

  Client := TIndySSEClient.Create(URL);
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
  inherited Create;

  SSE_URL := URL;

  EventStream := TIdEventStream.Create;
  EventStream.OnWrite := MyOnWrite;

  IdHTTP := TIdHTTP.Create;
  IdHTTP.Request.Accept := 'text/event-stream';
end;

destructor TIndySSEClient.Destroy;
begin
  IdHTTP.Free;
  EventStream.Free;

  inherited;
end;

procedure TIndySSEClient.Run;
begin
  IdHTTP.Get(SSE_URL, EventStream);
end;

procedure TIndySSEClient.MyOnWrite;
begin
  WriteLn('Received ' + IntToStr(Length(ABuffer)) + ' bytes');
  WriteLn;
  WriteLn(IndyTextEncoding_UTF8.GetString(ABuffer));

  Inc(ChunkCount);
  if ChunkCount > 2 then begin
    WriteLn('Closing connection');
    IdHTTP.Disconnect;
  end;
end;

end.

