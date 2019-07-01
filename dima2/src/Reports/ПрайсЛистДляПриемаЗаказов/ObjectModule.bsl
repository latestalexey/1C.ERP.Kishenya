#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	ВидыЦен = Новый СписокЗначений;
	ВидыЦен.ЗагрузитьЗначения(Справочники.ВидыЦен.ДоступныеВидыЦен());
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыЦен", ВидыЦен);
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
КонецПроцедуры

#КонецОбласти

#КонецЕсли