// Ожидаются параметры:
//
//     ИдентификаторОсновнойФормы      - УникальныйИдентификатор - Идентификатор формы, через хранилище которой
//                                                                 происходит обмен.
//     АдресСхемыКомпоновки            - Строка - Адрес временного хранилища схемы компоновки, для которой
//                                                редактируются настройки.
//     АдресНастроекКомпоновщикаОтбора - Строка - Адрес временного хранилища редактируемых настроек компоновщика.
//     ПредставлениеОбластиОтбора      - Строка - Представление для формирования заголовка.
//
// Возвращается результатом выбора:
//
//     Неопределено - Отказ от редактирования.
//     Строка       - Адрес временного хранилища новых настроек компоновщика.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторОсновнойФормы = Параметры.ИдентификаторОсновнойФормы;
	
	КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикПредварительногоОтбора.Инициализировать( 
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.АдресСхемыКомпоновки) );
		
	АдресНастроекКомпоновщикаОтбора = Параметры.АдресНастроекКомпоновщикаОтбора;
	КомпоновщикПредварительногоОтбора.ЗагрузитьНастройки(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновщикаОтбора));
	УдалитьИзВременногоХранилища(АдресНастроекКомпоновщикаОтбора);
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Правила отбора ""%1""';uk='Правила відбору ""%1""'"), Параметры.ПредставлениеОбластиОтбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Модифицированность Тогда
		ОповеститьОВыборе(АдресНастроекКомпоновщикаОтбора());
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресНастроекКомпоновщикаОтбора()
	Возврат ПоместитьВоВременноеХранилище(КомпоновщикПредварительногоОтбора.Настройки, ИдентификаторОсновнойФормы)
КонецФункции

#КонецОбласти

