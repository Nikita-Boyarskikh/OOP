(*****************************************************
 *                                                   *
 *  Шаблонизатор классов и функций                   *
 *                                                   *
 *  Использование:                                   *
 *      {$DEFINE TYPE_Template}                      *
 *      {$INCLUDE Templater.pas}                     *
 *                                                   *
 *  Теперь T - тип, равный TYPE                      *
 *  Можно создать много файлов с одинаковым кодом,   *
 *  различие будет только в директиве DEFINE         *
 *                                                   *
 *  Таким образом, можно создавать шаблонный код     *
 *  Для одинаковых действий с разными типами данных  *
 *                                                   *
 *  Пример:                                          *
 *      {$DEFINE Integer_Template}                   *
 *      {$INCLUDE Templater.pas}                     *
 *      var number : T;                              * 
 *      number := 12;                                *
 *                                                   *
 *  Автор: Боярских Никита                           *
 *         ИУ6-22 МГТУ им. Н. Э. Баумана             *
 *         8 (916) 385-76-22                         *
 *         N02@yandex.ru                              *
 *                                                   *
 *****************************************************)

{$IFDEF Shortint_Template}
{$UNDEF Integer_Template}
{$UNDEF Longint_Template}
{$UNDEF Single_Template}
{$UNDEF Real_Template}
{$UNDEF Double_Template}
{$UNDEF Extended_Template}
Type T = Shortint;
{$ENDIF}

{$IFDEF Integer_Template} 
{$UNDEF Shortint_Template}
{$UNDEF Longint_Template}
{$UNDEF Single_Template}
{$UNDEF Real_Template}
{$UNDEF Double_Template}
{$UNDEF Extended_Template}
Type T = Integer;
{$ENDIF}

{$IFDEF Longint_Template}
{$UNDEF Shortint_Template}
{$UNDEF Integer_Template}
{$UNDEF Single_Template}
{$UNDEF Real_Template}
{$UNDEF Double_Template}
{$UNDEF Extended_Template}
Type T = Longint;
{$ENDIF}

{$IFDEF Single_Template}
{$UNDEF Shortint_Template}
{$UNDEF Integer_Template}
{$UNDEF Longint_Template}
{$UNDEF Real_Template}
{$UNDEF Double_Template}
{$UNDEF Extended_Template}
Type T = Single;
{$ENDIF}

{$IFDEF Real_Template}
{$UNDEF Shortint_Template}
{$UNDEF Integer_Template}
{$UNDEF Longint_Template}
{$UNDEF Single_Template}
{$UNDEF Double_Template}
{$UNDEF Extended_Template}
Type T = Real;
{$ENDIF}

{$IFDEF Double_Template}
{$UNDEF Shortint_Template}
{$UNDEF Integer_Template}
{$UNDEF Longint_Template}
{$UNDEF Single_Template}
{$UNDEF Real_Template}
{$UNDEF Extended_Template}
Type T = Double;
{$ENDIF}

{$IFDEF Extended_Template} 
{$UNDEF Shortint_Template}
{$UNDEF Integer_Template}
{$UNDEF Longint_Template}
{$UNDEF Single_Template}
{$UNDEF Real_Template}
{$UNDEF Double_Template}
Type T = Extended;
{$ENDIF}
