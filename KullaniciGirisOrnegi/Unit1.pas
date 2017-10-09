unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, MemDS, DBAccess, Uni,
  UniProvider, ODBCUniProvider, AccessUniProvider, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Baglanti: TUniConnection;
    Provider: TAccessUniProvider;
    Sorgu: TUniQuery;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 with Sorgu do
 begin
   Close;  //Sorgu kapat�l�yor.
   SQL.Clear; //Ne olur ne olmaz SQL tahtam�z siliniyor.
   SQL.Text := 'select * from KullaniciGiris where (KAdi=:Kadi or KTelefon=:KTelefon) and KSifre=:KSifre'; //SQL sorgumuzu ekliyoruz.
   ParamByName('KAdi').Value := Edit1.Text;  //Parametlereler tan�mlan�yor..
   ParamByName('KTelefon').Value := Edit1.Text;  //Parametlereler tan�mlan�yor..
   ParamByName('KSifre').Value := Edit2.Text;   //Parametlereler tan�mlan�yor..
   Open;  //Sorgu a��l�yor.
 end;

  if Sorgu.RecordCount > 0 then    /// Kay�t say�s� e�er 0'dan b�y�k ise kullan�c� var ve giri� izni verilir.
  begin
    MessageBox(handle, 'Giri� ba�ar�yla ger�ekle�ti, tebrikler!', 'Tebrikler!', MB_OK + MB_ICONINFORMATION);
  end
  else
  begin
    if Sorgu.RecordCount <= 0 then     /// Kay�t say�s� 0 veya 0'dan k���k bir say� ise kullan�c� yok ve izin verilmez.
    begin
      MessageBox(handle, 'Kullanici Adi veya �ifre Yanl��!', 'Bi Yanl��l�k Var!', MB_OK + MB_ICONWARNING);
    end;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 try
   with Baglanti do
  begin
   ProviderName := 'Access';  //Veritaban� t�r�n� belirler.
   Database := 'Data.mdb'; //Uygulaman�n bulundu�u yolu i�aret eder.
   // Password := **** --> �ifre oldu�unda bu parametre kullan�r.
   Connected := True; //Ba�lant�y� a�t�ran komut.


      with Sorgu do
      begin
        Connection := Baglanti; //Baglanti connection bile�enimizi query bile�enine tan�t�yoruz.
      end;

  MessageBox(handle, 'Veritaban� ile ba�lant� ba�ar�yla sa�land�!', 'Ba�ar�l�!', MB_OK + MB_ICONINFORMATION);

  end;
 except
   MessageBox(handle, 'Veritaban� ba�lant� hatas�!', 'Hata!', MB_OK + MB_ICONERROR);
   Application.Terminate;  ///Program kapatma komutu.
 end;
end;

end.
