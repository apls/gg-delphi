unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Math;

type
  TTopic = class(TObject)
    op: Integer;
    a, b, c: Integer;
    opt: array[0..4] of Integer;
  end;
  
  TFormMain = class(TForm)
    btnStart: TButton;
    edtPwd: TEdit;
    btnSkip: TButton;
    btnConfig: TButton;
    pnlMathTest: TPanel;
    pnlMain: TPanel;
    pbProgress: TProgressBar;
    lblFormula: TLabel;
    btnOption1: TButton;
    btnOption2: TButton;
    btnOption3: TButton;
    btnOption4: TButton;
    btnOption5: TButton;
    btnRefresh: TButton;
    btnQuit: TButton;
    imgCorrect: TImage;
    imgWrong: TImage;
    procedure edtPwdChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnOptionClick(Sender: TObject);
  private
    { Private declarations }
    Count: Integer;
    Level: Integer;
    Current: Integer;
    Topics: array of TTopic;
    procedure InitTopics;
    procedure LoadTopic;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}  

procedure Delay(msecs:integer);  //ÑÓ³Ùº¯Êý ±ÈsleepºÃ 
var
  Tick: DWord; 
  Event: THandle; 
begin
  Event := CreateEvent(nil, False, False, nil); 
  try
    Tick := GetTickCount + DWord(msecs); 
    while (msecs > 0) and (MsgWaitForMultipleObjects(1, Event, False, msecs, QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages; 
      msecs := Tick - GetTickcount; 
    end; 
  finally
    CloseHandle(Event); 
  end;
end;

procedure TFormMain.edtPwdChange(Sender: TObject);
var
  b: Boolean;
begin
  b := edtPwd.Text = 'pwd';
  btnSkip.Enabled := b;
  btnConfig.Enabled := b;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  if pnlMain.Visible then
  begin
    edtPwd.SelectAll;
    edtPwd.SetFocus;
  end;  
end;

procedure TFormMain.btnStartClick(Sender: TObject);
begin
  pnlMain.Hide;     
  InitTopics;
  LoadTopic;     
  pnlMathTest.Show;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Count := 10;
  Level := 15;
  Current := -1;
end;

procedure TFormMain.LoadTopic;
var
	s: String;
begin
  imgCorrect.Hide;
  imgWrong.Hide;
	Inc(Current);
	if Current = Count then
  begin
    Close;
    Exit;
  end;
       
  pbProgress.Position := Current + 1;
	with Topics[Current] do
  begin
    s := IntToStr(a);
    if op = 0 then
      s := s + ' + '
    else  
      s := s + ' - ';
    s := s + IntToStr(b) + ' = ?';
    lblFormula.Caption := s;

    btnOption1.Caption := IntToStr(opt[0]);
    btnOption2.Caption := IntToStr(opt[1]);
    btnOption3.Caption := IntToStr(opt[2]);
    btnOption4.Caption := IntToStr(opt[3]);
    btnOption5.Caption := IntToStr(opt[4]);
    btnOption1.Enabled := True;
    btnOption2.Enabled := True;
    btnOption3.Enabled := True;
    btnOption4.Enabled := True;
    btnOption5.Enabled := True;
  end;
end;

procedure TFormMain.InitTopics;
var
  i, a, b, c, op: Integer;
begin
  pbProgress.Position := 0;
  pbProgress.Max := Count;
  SetLength(Topics, Count);
  Current := -1;

  for i:=0 to Count - 1 do
  begin
    Topics[i] := TTopic.Create;
    a := Random(Level);
    b := Random(Level);
    op := Random(2);
		if op = 0 then
    begin
      c := max(a, b);
      a := min(a, b);
      b := c - a;
    end
    else
    begin
			c := max(a, b);
			b := min(a, b);
			a := c;
			c := a - b;
    end;

		Topics[i].a := a;
		Topics[i].b := b;
		Topics[i].c := c;
		Topics[i].op := op;
		
		c := c - Random(min(c, 5));
		for a := 0 to 4 do
    begin
      Inc(c);
			Topics[i].opt[a] := c;
    end;
  end;  
end;

procedure TFormMain.btnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.btnOptionClick(Sender: TObject); 
var
  i, x: Integer;
begin
  btnOption1.Enabled := False;
  btnOption2.Enabled := False;
  btnOption3.Enabled := False;
  btnOption4.Enabled := False;
  btnOption5.Enabled := False;

  i := (Sender as TControl).Tag;
  x := i * (200 - 72) + 72;
	with Topics[Current] do
  begin
    if opt[i] = c then
    begin
      imgCorrect.Left := x;
      imgCorrect.Show;
    end
    else
    begin
      imgWrong.Left := x;
      imgWrong.Show;
    end;
  end;
  
  Delay(500);
  LoadTopic;
end;

end.
