
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Бригада = Параметры.Бригада;
	
	Дата = КонецДня(ТекущаяДатаСеанса());
	
	ПолучитьСведенияОСоставеНаСервере();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ПолучитьСведенияОСоставеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Документ) Тогда
		ПоказатьЗначение(Неопределено, Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСоздатьНажатие(Элемент)
	
	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("Бригада", Бригада);
	ЗначенияЗаполнения.Вставить("НачалоПериода", Дата);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ФормированиеСоставаБригады.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	ПолучитьСведенияОСоставеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьСведенияОСоставеНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ФормированиеСоставаБригады.НачалоПериода) КАК Дата
	|ПОМЕСТИТЬ СоставНаДату
	|ИЗ
	|	Документ.ФормированиеСоставаБригады КАК ФормированиеСоставаБригады
	|ГДЕ
	|	ФормированиеСоставаБригады.НачалоПериода <= &Дата
	|	И ФормированиеСоставаБригады.Бригада = &Бригада
	|	И ФормированиеСоставаБригады.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ФормированиеСоставаБригады.НачалоПериода) КАК Дата
	|ПОМЕСТИТЬ СледующийСостав
	|ИЗ
	|	Документ.ФормированиеСоставаБригады КАК ФормированиеСоставаБригады
	|ГДЕ
	|	ФормированиеСоставаБригады.НачалоПериода > &Дата
	|	И ФормированиеСоставаБригады.Бригада = &Бригада
	|	И ФормированиеСоставаБригады.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставНаДату.Дата КАК ДействуетС,
	|	ФормированиеСоставаБригады.Ссылка КАК Документ,
	|	ЕСТЬNULL(СледующийСостав.Дата, 0) КАК ДействуетПо,
	|	ФормированиеСоставаБригады.Номер КАК Номер,
	|	ФормированиеСоставаБригады.Дата КАК Дата
	|ИЗ
	|	СоставНаДату КАК СоставНаДату
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ФормированиеСоставаБригады КАК ФормированиеСоставаБригады
	|		ПО СоставНаДату.Дата = ФормированиеСоставаБригады.НачалоПериода,
	|	СледующийСостав КАК СледующийСостав
	|ГДЕ
	|	ФормированиеСоставаБригады.Бригада = &Бригада
	|	И ФормированиеСоставаБригады.Проведен";
	
	Запрос.УстановитьПараметр("Бригада", Бригада);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	ШаблонОбщейНадписи = НСтр("ru='Действует с %1 по %2.';uk='Діє з %1 по %2.'");
	ШаблонНадписиДокумента = НСтр("ru='Формирование состава №%1 от %2';uk='Формування складу №%1 від %2'");
	
	НадписьОбщая = "";
	Документ = Документы.ФормированиеСоставаБригады.ПустаяСсылка();
	
	Пока Выборка.Следующий() Цикл
		
		Документ = Выборка.Документ;
		
		Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.Номер);
		ДатаДокумента = Формат(Выборка.Дата, "ДЛФ=D");
		ДействуетС = Формат(Выборка.ДействуетС, "ДЛФ=D");
		
		Если ЗначениеЗаполнено(Выборка.ДействуетПо) Тогда
			ДействуетПо = Формат(Выборка.ДействуетПо, "ДЛФ=D");
		Иначе
			ДействуетПо = НСтр("ru='настоящее время';uk='теперішній час'");
		КонецЕсли;
		
		НадписьОбщая = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОбщейНадписи, ДействуетС, ДействуетПо);
		НадписьДокумент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНадписиДокумента, Номер, ДатаДокумента);
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(НадписьОбщая) Тогда
		
		НадписьОбщая = НСтр("ru='Состав бригады не задан.';uk='Склад бригади не заданий.'");
		
		Элементы.НадписьДокумент.Видимость = Ложь;
	Иначе
		Элементы.НадписьДокумент.Видимость = Истина;
	КонецЕсли;
	
	СотрудникиБригады.Параметры.УстановитьЗначениеПараметра("Ссылка", Документ);
	
КонецПроцедуры

#КонецОбласти
