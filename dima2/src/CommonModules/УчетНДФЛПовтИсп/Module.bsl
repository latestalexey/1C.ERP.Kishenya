
#Область СлужебныеПроцедурыИФункции

Функция КодыДоходовПоЦеннымБумагам(НалоговыйПериод) Экспорт
	
	СтрокаКодовДоходовПоЦеннымБумагам = "1010,1110,1120,1530,1531,1532,1533,1535,1536,1537,1538,1539,1541,1540,1543,2640,2641,2800";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыДоходовНДФЛ.Ссылка
	|ИЗ
	|	Справочник.ВидыДоходовНДФЛ КАК ВидыДоходовНДФЛ
	|ГДЕ
	|	ВидыДоходовНДФЛ.КодПрименяемыйВНалоговойОтчетностиС2010Года В(&КодыДоходов)";
	Запрос.УстановитьПараметр("КодыДоходов", СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаКодовДоходовПоЦеннымБумагам));
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")
	
КонецФункции

Функция КодВычетаДляНалоговойОтчетности(НалоговыйПериод, КодВычета) Экспорт

	КодыДляНалоговойОтчетности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КодВычета, "КодПрименяемыйВНалоговойОтчетностиС2015Года,КодПрименяемыйВНалоговойОтчетностиС2011Года,КодПрименяемыйВНалоговойОтчетностиС2010Года");	
	Если НалоговыйПериод < 2011 Тогда
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2010Года
	ИначеЕсли НалоговыйПериод < 2015 Тогда
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2011Года
	Иначе
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2015Года
	КонецЕсли;
	
КонецФункции 

Функция ГруппаВычета(КодВычета) Экспорт

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодВычета, "ГруппаВычета"); 
	
КонецФункции 

Функция ОпределитьНалоговыйПериод(ПериодРегистрации, ПериодДействия, ДоходНДФЛ, КатегорияНачисления) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДоходНДФЛ) Тогда
		Возврат Дата(1,1,1);
	КонецЕсли;
	
	//Отпуска учитываются по периоду действия, если он за текущий или будущий период
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска Тогда
		Возврат МАКС(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста
		ИЛИ КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя
		ИЛИ КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве Тогда
		//Больничные учитываются по периоду действия, если он за текущий или прошедший период
		Возврат МИН(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам Тогда
		//Декретные учитываются по периоду действия, если он за текущий или будущий период
		Возврат МАКС(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	//Все прочие учитываются по периоду регистрации
	Возврат ПериодРегистрации;
	
КонецФункции

Функция ВидУдержанияПоКодуДохода(КодДохода) Экспорт
	
	Если КодДохода.ВидСтавкиРезидента = Перечисления.ВидыСтавокНДФЛ.ВоенныйСбор Тогда
		Возврат Перечисления.ВидыОсобыхНачисленийИУдержаний.ВоенныйСбор;
	Иначе
		Возврат Перечисления.ВидыОсобыхНачисленийИУдержаний.НДФЛ;	
	КонецЕсли;
	
КонецФункции	


#КонецОбласти
