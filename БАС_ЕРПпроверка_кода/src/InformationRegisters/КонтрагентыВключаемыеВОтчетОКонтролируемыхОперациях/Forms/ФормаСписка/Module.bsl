&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Организация") Тогда
	    Организация = Параметры.Организация;
	Иначе	
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");	
	КонецЕсли;
	
	Если Параметры.Свойство("Год") Тогда
	    Год = Параметры.Год;
	Иначе	
		Год = Год(ТекущаяДата()) - 1;
	КонецЕсли;
	
	УстановитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	УстановитьОтбор(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГодОтборПриИзменении(Элемент)
	
	УстановитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтбор(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список, "Организация", Форма.Организация, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список, "Период", 	 Дата(Форма.Год,1,1), ВидСравненияКомпоновкиДанных.Равно,, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНумерациюПриложений(Команда)
	
	Если НЕ ЗначениеЗаполнено(Год) Тогда
		Сообщить(НСтр("ru='Не указан год! Операция не выполнена';uk='Не вказаний рік! Операція не виконана'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщить(НСтр("ru='Не указана организация! Операция не выполнена';uk='Не вказана організація! Операція не виконана'"));
		Возврат;
	КонецЕсли;
	
	ВосстановитьНумерациюПриложенийНаСервере(Год, Организация);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВосстановитьНумерациюПриложенийНаСервере(Год, Организация)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Рег.Период,
	               |	Рег.Организация,
	               |	Рег.Контрагент,
	               |	Рег.НомерПриложенияОтчета
	               |ИЗ
	               |	РегистрСведений.КонтрагентыВключаемыеВОтчетОКонтролируемыхОперациях КАК Рег
	               |ГДЕ Период  = &Период
				   |	И Организация = &Организация
	               |УПОРЯДОЧИТЬ ПО
	               |	Контрагент.Наименование
				   |";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", 	 Дата(Год, 1, 1));
	
	ТаблицаУпорядоченная = Запрос.Выполнить().Выгрузить();
	Для каждого Строка Из ТаблицаУпорядоченная Цикл
		Строка.НомерПриложенияОтчета = ТаблицаУпорядоченная.Индекс(Строка) + 1;
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.КонтрагентыВключаемыеВОтчетОКонтролируемыхОперациях.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Период.Значение 		= Дата(Год, 1, 1);
	НаборЗаписей.Отбор.Период.Использование = Истина;
	
	НаборЗаписей.Отбор.Организация.Использование = Истина;
	НаборЗаписей.Отбор.Организация.Значение 	 = Организация;
	
	НаборЗаписей.Загрузить(ТаблицаУпорядоченная);
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		Сообщить(НСтр("ru='Не удалось перенумеровать строки приложений отчета! ';uk='Не вдалося пронумерувати рядки додатків звіту! '") + ОписаниеОшибки()); 	
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписок(Команда)
	
	Если НЕ ЗначениеЗаполнено(Год) Тогда
		Сообщить(НСтр("ru='Не указан год! Операция не выполнена';uk='Не вказаний рік! Операція не виконана'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщить(НСтр("ru='Не указана организация! Операция не выполнена';uk='Не вказана організація! Операція не виконана'"));
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокНаСервере(Год, Организация);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокНаСервере(Год, Организация)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОбщиеСведенияОКонтролируемыхОперацияхОбороты.Организация,
	               |	ОбщиеСведенияОКонтролируемыхОперацияхОбороты.Контрагент,
	               |	ОбщиеСведенияОКонтролируемыхОперацияхОбороты.СуммаОбщаяОборот,
				   |	0 КАК НомерПриложенияОтчета,
				   |	&Период КАК Период,
				   |	ОбщиеСведенияОКонтролируемыхОперацияхОбороты.СуммаКонтролируемыхОперацийОборот
	               |ИЗ
	               |	РегистрНакопления.ОбщиеСведенияОКонтролируемыхОперациях.Обороты(НАЧАЛОПЕРИОДА(&Период, ГОД), КОНЕЦПЕРИОДА(&Период, ГОД), , Организация = &Организация) КАК ОбщиеСведенияОКонтролируемыхОперацияхОбороты
	               |ГДЕ
	               |	ОбщиеСведенияОКонтролируемыхОперацияхОбороты.СуммаКонтролируемыхОперацийОборот   > &Предел
	               //|	И ОбщиеСведенияОКонтролируемыхОперацияхОбороты.СуммаКонтролируемыхОперацийОборот > 0
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ОбщиеСведенияОКонтролируемыхОперацияхОбороты.Контрагент.Наименование
				   |";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", 	 Дата(Год, 1, 1));
	Запрос.УстановитьПараметр("Предел",		 КонтролируемыеОперацииПовтИсп.ОграничениеСуммыВсехОпераций(Год));
	
	ТаблицаУпорядоченная = Запрос.Выполнить().Выгрузить();
	Для каждого Строка Из ТаблицаУпорядоченная Цикл
		Строка.НомерПриложенияОтчета = ТаблицаУпорядоченная.Индекс(Строка) + 1;
		Строка.Период 				 =  Дата(Год, 1, 1);
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.КонтрагентыВключаемыеВОтчетОКонтролируемыхОперациях.СоздатьНаборЗаписей();

	НаборЗаписей.Отбор.Период.Значение 		= Дата(Год, 1, 1);
	НаборЗаписей.Отбор.Период.Использование = Истина;
	
	НаборЗаписей.Отбор.Организация.Использование = Истина;
	НаборЗаписей.Отбор.Организация.Значение 	 = Организация;

	НаборЗаписей.Загрузить(ТаблицаУпорядоченная);
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		Сообщить(НСтр("ru='Не удалось заполнить список! ';uk='Не вдалося заповнити список! '") + ОписаниеОшибки()); 	
	КонецПопытки;
	
КонецПроцедуры
