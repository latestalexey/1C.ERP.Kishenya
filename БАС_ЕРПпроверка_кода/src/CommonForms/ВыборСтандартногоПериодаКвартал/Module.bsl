
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НачалоПериода, КонецПериода");
	ДатаНачалаГода = ?(ЗначениеЗаполнено(КонецПериода), НачалоГода(КонецПериода), НачалоГода(ТекущаяДатаСеанса()));
	ЦветТекущегоПериода = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
	
	НарастающимИтогом = Параметры.Свойство("НарастающимИтогом") И Параметры.НарастающимИтогом;
	Элементы.ГруппаПериоды.ТекущаяСтраница =
		?(НарастающимИтогом,
			Элементы.ГруппаНарастающимИтогом,
			Элементы.ГруппаКварталы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерейтиНаГодНазад(Команда)
	
	ДатаНачалаГода = НачалоГода(ДатаНачалаГода - 1);
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаГодВперед(Команда)
	
	ДатаНачалаГода = КонецГода(ДатаНачалаГода) + 1;
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал1(Команда)
	
	ВыбратьКвартал(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал2(Команда)
	
	ВыбратьКвартал(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал3(Команда)
	
	ВыбратьКвартал(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал4(Команда)
	
	ВыбратьКвартал(4);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьАктивныйПериод()
	
	Если НарастающимИтогом Тогда
		НомерКвартала = Месяц(КонецКвартала(КонецПериода)) / 3;
		ТекущийЭлемент = Элементы["ВыбратьКвартал" + НомерКвартала + "Нарастающим"];
		ТекущийЭлемент.ЦветФона = ЦветТекущегоПериода;
	Иначе
		Если НачалоКвартала(НачалоПериода) = НачалоКвартала(КонецПериода) Тогда
			НомерКвартала = Месяц(КонецКвартала(НачалоПериода)) / 3;
			ТекущийЭлемент = Элементы["ВыбратьКвартал" + НомерКвартала];
			ТекущийЭлемент.ЦветФона = ЦветТекущегоПериода;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборПериода()
	
	РезультатВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецДня(КонецПериода));
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал(НомерКвартала)
	
	НачалоПериодаКвартал = Дата(Год(ДатаНачалаГода), НомерКвартала * 3 - 2, 1);
	КонецПериода = КонецКвартала(НачалоПериодаКвартал);
	Если НарастающимИтогом Тогда
		НачалоПериода = ДатаНачалаГода;
	Иначе
		НачалоПериода = НачалоПериодаКвартал;
	КонецЕсли;
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры
