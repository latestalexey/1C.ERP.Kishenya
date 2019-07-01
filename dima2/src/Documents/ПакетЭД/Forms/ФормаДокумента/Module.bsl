
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.КомандаРаспаковатьПакетЭД.Видимость = Объект.СтатусПакета = Перечисления.СтатусыПакетовЭД.КРаспаковке;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтатусПакета = Объект.СтатусПакета;
	ЗаполнитьСписокВыбораСтатусовПакета();
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.СтатусПакета = СтатусПакета Тогда
		ТекущийОбъект.СтатусПакета = СтатусПакета;
	КонецЕсли;
	
	СтатусПакета = Объект.СтатусПакета;
	ЗаполнитьСписокВыбораСтатусовПакета();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭлектронныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ЭлектронныеДокументыОбъектВладелец" Тогда
		ПоказатьЗначение(,Элемент.ТекущиеДанные.ОбъектВладелец);
		
	ИначеЕсли ТипЗнч(Элемент.ТекущиеДанные.ЭлектронныйДокумент) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(Элемент.ТекущиеДанные.ЭлектронныйДокумент);
	
	Иначе
		ПоказатьЗначение(,Элемент.ТекущиеДанные.ЭлектронныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭДОПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыНастройкаЭДОПриИзменении()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РаспаковатьПакетЭД(Команда)
	
	МассивПЭД = Новый Массив;
	МассивПЭД.Добавить(Объект.Ссылка);
	ОбменСКонтрагентамиСлужебныйКлиент.РаспаковатьПакетыЭДНаКлиенте(МассивПЭД);
	Прочитать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораСтатусовПакета()
	
	Если Объект.Направление = Перечисления.НаправленияЭД.Входящий Тогда
		Элементы.СтатусПакета.СписокВыбора.ЗагрузитьЗначения(СписокСтатусовВходящий());
	Иначе
		Элементы.СтатусПакета.СписокВыбора.ЗагрузитьЗначения(СписокСтатусовИсходящий());
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокСтатусовВходящий()
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.КРаспаковке);
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.Распакован);
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.РаспакованДокументыНеОбработаны);
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.Неизвестный);
	
	Возврат МассивСтатусов;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокСтатусовИсходящий()
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.Доставлен);
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.Отменен);
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.Отправлен);
	МассивСтатусов.Добавить(Перечисления.СтатусыПакетовЭД.ПодготовленКОтправке);
	
	Возврат МассивСтатусов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыНастройкаЭДОПриИзменении()
	
	Объект.Отправитель = Объект.НастройкаЭДО.ИдентификаторКонтрагента;
	Объект.Получатель = Объект.НастройкаЭДО.ИдентификаторОрганизации;
	Объект.Контрагент = Объект.НастройкаЭДО.Контрагент;
	СтатусПакета = Перечисления.СтатусыПакетовЭД.КРаспаковке;
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
	Если Не ЗначениеЗаполнено(Объект.НастройкаЭДО) Тогда
		Элементы.НастройкаЭДО.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


