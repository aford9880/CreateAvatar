program Testing;

uses
  Vcl.Forms,
  UnitTesting in 'UnitTesting.pas' {FrmTesting};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  Application.CreateForm(TFrmTesting, FrmTesting);
  Application.Run;
end.
