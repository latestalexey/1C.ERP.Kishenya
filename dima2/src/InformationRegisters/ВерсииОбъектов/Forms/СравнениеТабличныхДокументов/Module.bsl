
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТабличныеДокументыДляСравнения = ПолучитьИзВременногоХранилища(Параметры.АдресТабличныхДокументов);
	ТабличныйДокументЛевый = ТабличныеДокументыДляСравнения.Левый;
	ТабличныйДокументПравый = ТабличныеДокументыДляСравнения.Правый;
	
	Элементы.ГруппаЛевыйТабличныйДокумент.Заголовок = Параметры.ЗаголовокЛевый;
	Элементы.ГруппаПравыйТабличныйДокумент.Заголовок = Параметры.ЗаголовокПравый;
	
	СравнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабличныйДокументЛевый

&НаКлиенте
Процедура ТабличныйДокументЛевыйПриАктивизацииОбласти(Элемент)
	
	Если БлокировкаОбработкиАктивизации = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Источник = Новый Структура("Объект, Элемент", ТабличныйДокументЛевый, Элементы.ТабличныйДокументЛевый);
	Приемник = Новый Структура("Объект, Элемент", ТабличныйДокументПравый, Элементы.ТабличныйДокументПравый);
	
	СоответствияИсточник = Новый Структура("Строки, Столбцы", СоответствиеСтрокЛевый, СоответствиеСтолбцовЛевый);
	СоответствияПриемник = Новый Структура("Строки, Столбцы", СоответствиеСтрокПравый, СоответствиеСтолбцовПравый);
	
	ОбработатьАктивизациюОбласти(Источник, Приемник, СоответствияИсточник, СоответствияПриемник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабличныйДокументПравый

&НаКлиенте
Процедура ТабличныйДокументПравыйПриАктивизацииОбласти(Элемент)
	
	Если БлокировкаОбработкиАктивизации = Истина Тогда
		Возврат;
	КонецЕсли;
		
	Источник = Новый Структура("Объект, Элемент", ТабличныйДокументПравый, Элементы.ТабличныйДокументПравый);
	Приемник = Новый Структура("Объект, Элемент", ТабличныйДокументЛевый, Элементы.ТабличныйДокументЛевый);
	
	СоответствияИсточник = Новый Структура("Строки, Столбцы", СоответствиеСтрокПравый, СоответствиеСтолбцовПравый);
	СоответствияПриемник = Новый Структура("Строки, Столбцы", СоответствиеСтрокЛевый, СоответствиеСтолбцовЛевый);
	
	ОбработатьАктивизациюОбласти(Источник, Приемник, СоответствияИсточник, СоответствияПриемник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПредыдущееИзменениеЛевый(Команда)
	
	ПредыдущееИзменение(Элементы.ТабличныйДокументЛевый, ТабличныйДокументЛевый, РазличияЯчеекЛевый);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПредыдущееИзменениеПравый(Команда)
	
	ПредыдущееИзменение(Элементы.ТабличныйДокументПравый, ТабличныйДокументПравый, РазличияЯчеекПравый);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСледующееИзменениеЛевый(Команда)
	
	СледующееИзменение(Элементы.ТабличныйДокументЛевый, ТабличныйДокументЛевый, РазличияЯчеекЛевый);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСледующееИзменениеПравый(Команда)
	
	СледующееИзменение(Элементы.ТабличныйДокументПравый, ТабличныйДокументПравый, РазличияЯчеекПравый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СравнитьНаСервере()

	БлокировкаОбработкиАктивизации = Истина;
			
	СоответствиеСтрокЛевый = Новый СписокЗначений;
	СоответствиеСтрокПравый = Новый СписокЗначений;
	
	СоответствиеСтолбцовЛевый = Новый СписокЗначений;
	СоответствиеСтолбцовПравый = Новый СписокЗначений;
	
	РазличияЯчеекЛевый.Очистить();
	РазличияЯчеекПравый.Очистить();
	
	ВыполнитьСравнение();
	
	БлокировкаОбработкиАктивизации = Ложь;
	
КонецПроцедуры	

&НаСервере
Процедура ВыполнитьСравнение()
	
	#Область Сравнение
	
	// Тексты из ячеек табличных документов выгружается в таблицы значений.
	ТаблицаЛевогоДокумента = ПолучитьТаблицуЗначенийИзДокумента(ТабличныйДокументЛевый);
	ТаблицаПравогоДокумента = ПолучитьТаблицуЗначенийИзДокумента(ТабличныйДокументПравый);
	
	// Сравниваются табличные документы по строкам и подбираются соответствия строк.
	Соответствия = СформироватьСоответствия(ТаблицаЛевогоДокумента, ТаблицаПравогоДокумента, Истина);
	СоответствиеСтрокЛевый = Соответствия[0];
	СоответствиеСтрокПравый = Соответствия[1];
	
	// Сравниваются табличные документы по столбцам и подбираются соответствия столбцов.
	Соответствия = СформироватьСоответствия(ТаблицаЛевогоДокумента, ТаблицаПравогоДокумента, Ложь);
	СоответствиеСтолбцовЛевый = Соответствия[0];
	СоответствиеСтолбцовПравый = Соответствия[1];
	
	ТаблицаЛевогоДокумента = Неопределено;
	ТаблицаПравогоДокумента = Неопределено;
	
	#КонецОбласти
	
	#Область ГрафическоеОтображениеРазличий
	
	ЦветОбластиУдаленнойФон	= ЦветаСтиля.УдаленныйРеквизитФон;
	ЦветОбластиДобавленнойФон	= ЦветаСтиля.ДобавленныйРеквизитФон;
	ЦветОбластиИзмененнойФон	= ЦветаСтиля.ИзмененноеЗначениеРеквизитаФон;
	ЦветОбластиИзмененнойТекст	= ЦветаСтиля.ИзмененноеЗначениеРеквизитаЦвет;
		
	
	ВысотаЛевойТаблицы = ТабличныйДокументЛевый.ВысотаТаблицы;
	ШиринаЛевойТаблицы = ТабличныйДокументЛевый.ШиринаТаблицы;
	
	ВысотаПравойТаблицы = ТабличныйДокументПравый.ВысотаТаблицы;
	ШиринаПравойТаблицы = ТабличныйДокументПравый.ШиринаТаблицы;

	// Строки которые были удалены из левого табличного документа.
	Для НомерСтроки = 1 По СоответствиеСтрокЛевый.Количество()-1 Цикл
		
		Если СоответствиеСтрокЛевый[НомерСтроки].Значение = Неопределено Тогда
			
			Область = ТабличныйДокументЛевый.Область(НомерСтроки, 1, НомерСтроки, ШиринаЛевойТаблицы);
			Область.ЦветФона = ЦветОбластиУдаленнойФон;
			
			НоваяСтрокаРазличий = РазличияЯчеекЛевый.Добавить();
			НоваяСтрокаРазличий.НомерСтроки = НомерСтроки;
			НоваяСтрокаРазличий.НомерСтолбца = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Столбцы которые были удалены из левого табличного документа.
	Для НомерСтолбца = 1 По СоответствиеСтолбцовЛевый.Количество()-1 Цикл
		
		Если СоответствиеСтолбцовЛевый[НомерСтолбца].Значение = Неопределено Тогда
			
			Область = ТабличныйДокументЛевый.Область(1, НомерСтолбца, ВысотаЛевойТаблицы, НомерСтолбца);
			Область.ЦветФона = ЦветОбластиУдаленнойФон;
			
			НоваяСтрокаРазличий = РазличияЯчеекЛевый.Добавить();
			НоваяСтрокаРазличий.НомерСтроки = 0;
			НоваяСтрокаРазличий.НомерСтолбца = НомерСтолбца;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Строки которые были добавлены в правый табличный документ.
	Для НомерСтроки = 1 По СоответствиеСтрокПравый.Количество()-1 Цикл
		
		Если СоответствиеСтрокПравый[НомерСтроки].Значение = Неопределено Тогда
			
			Область = ТабличныйДокументПравый.Область(НомерСтроки, 1, НомерСтроки, ШиринаПравойТаблицы);
			Область.ЦветФона = ЦветОбластиДобавленнойФон;
			
			НоваяСтрокаРазличий = РазличияЯчеекПравый.Добавить();
			НоваяСтрокаРазличий.НомерСтроки = НомерСтроки;
			НоваяСтрокаРазличий.НомерСтолбца = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Столбцы которые были добавлены в правый табличный документ.
	Для НомерСтолбца = 1 По СоответствиеСтолбцовПравый.Количество()-1 Цикл
		
		Если СоответствиеСтолбцовПравый[НомерСтолбца].Значение = Неопределено Тогда
			
			Область = ТабличныйДокументПравый.Область(1, НомерСтолбца, ВысотаПравойТаблицы, НомерСтолбца);
			Область.ЦветФона = ЦветОбластиДобавленнойФон;
			
			НоваяСтрокаРазличий = РазличияЯчеекПравый.Добавить();
			НоваяСтрокаРазличий.НомерСтроки = 0;
			НоваяСтрокаРазличий.НомерСтолбца = НомерСтолбца;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Ячейки которые были изменены
	Для НомерСтроки1 = 1 По СоответствиеСтрокЛевый.Количество()-1 Цикл
		
		НомерСтроки2 = СоответствиеСтрокЛевый[НомерСтроки1].Значение;
		Если НомерСтроки2 = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Для НомерСтолбца1 = 1 По СоответствиеСтолбцовЛевый.Количество()-1 Цикл
			
			НомерСтолбца2 = СоответствиеСтолбцовЛевый[НомерСтолбца1].Значение;
			Если НомерСтолбца2 = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Область1 = ТабличныйДокументЛевый.Область(НомерСтроки1, НомерСтолбца1, НомерСтроки1, НомерСтолбца1);
			Область2 = ТабличныйДокументПравый.Область(НомерСтроки2, НомерСтолбца2, НомерСтроки2, НомерСтолбца2);
			
			Если НЕ СравнитьОбласти(Область1, Область2) Тогда
				
				Область1 = ТабличныйДокументЛевый.Область(НомерСтроки1, НомерСтолбца1);
				Область2 = ТабличныйДокументПравый.Область(НомерСтроки2, НомерСтолбца2);
				
				Область1.ЦветТекста = ЦветОбластиИзмененнойТекст;
				Область2.ЦветТекста = ЦветОбластиИзмененнойТекст;
				
				Область1.ЦветФона = ЦветОбластиИзмененнойФон;
				Область2.ЦветФона = ЦветОбластиИзмененнойФон;
				
				
				НоваяСтрокаРазличий = РазличияЯчеекЛевый.Добавить();
				НоваяСтрокаРазличий.НомерСтроки = НомерСтроки1;
				НоваяСтрокаРазличий.НомерСтолбца = НомерСтолбца1;
				
				НоваяСтрокаРазличий = РазличияЯчеекПравый.Добавить();
				НоваяСтрокаРазличий.НомерСтроки = НомерСтроки2;
				НоваяСтрокаРазличий.НомерСтолбца = НомерСтолбца2;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	РазличияЯчеекЛевый.Сортировать("НомерСтроки, НомерСтолбца");
	РазличияЯчеекПравый.Сортировать("НомерСтроки, НомерСтолбца");
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Функция СравнитьОбласти(Область1, Область2)
	
	Если Область1.Текст <> Область2.Текст Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Область1.Примечание.Текст <> Область2.Примечание.Текст Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуЗначенийИзДокумента(ТабличныйДокументИсточник)
	
	КоличествоСтолбцов = ТабличныйДокументИсточник.ШиринаТаблицы;
	
	Если КоличествоСтолбцов = 0 Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Для НомерСтолбца = 1 По КоличествоСтолбцов Цикл
		ТабличныйДокумент.Область(1, НомерСтолбца, 1, НомерСтолбца).Текст = "Номер_" + Формат(НомерСтолбца,"ЧГ=0");
	КонецЦикла;
	
	ТабличныйДокумент.Вывести(ТабличныйДокументИсточник);
	
	Построитель = Новый ПостроительЗапроса;
	
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТабличныйДокумент.Область());
	Построитель.Выполнить();
	ТаблицаЗначенийРезультат = Построитель.Результат.Выгрузить();
	
	Возврат ТаблицаЗначенийРезультат;
	
КонецФункции

&НаСервере
Функция СформироватьСоответствия(ТаблицаЛевая, ТаблицаПравая, ПоСтрокам)
	
	ДанныеИзТаблицыЛевая = ПолучитьДанныеДляСравнения(ТаблицаЛевая, ПоСтрокам);
	
	ДанныеИзТаблицыПравая = ПолучитьДанныеДляСравнения(ТаблицаПравая, ПоСтрокам);
	
	Если ПоСтрокам Тогда
		РезультатСоответствияЛевая = Новый СписокЗначений;
		РезультатСоответствияЛевая.ЗагрузитьЗначения(Новый Массив(ТаблицаЛевая.Количество()+1));
		
		РезультатСоответствияПравая = Новый СписокЗначений;
		РезультатСоответствияПравая.ЗагрузитьЗначения(Новый Массив(ТаблицаПравая.Количество()+1));		
		
	Иначе
		РезультатСоответствияЛевая = Новый СписокЗначений;
		РезультатСоответствияЛевая.ЗагрузитьЗначения(Новый Массив(ТаблицаЛевая.Колонки.Количество()+1));
		
		РезультатСоответствияПравая = Новый СписокЗначений;
		РезультатСоответствияПравая.ЗагрузитьЗначения(Новый Массив(ТаблицаПравая.Колонки.Количество()+1));
		
	КонецЕсли;
	
	ТекстЗапроса = "";
	
	ТекстЗапроса = ТекстЗапроса + "	ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаЛевая 
								|	ИЗ &ДанныеИзТаблицыЛевая КАК ДанныеИзТаблицыЛевая;" + Символы.ПС;
								
	ТекстЗапроса = ТекстЗапроса + "	ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаПравая
								|	ИЗ &ДанныеИзТаблицыПравая КАК ДанныеИзТаблицыПравая;" + Символы.ПС;
		
	ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ
		|	ТаблицаЛевая.Номер КАК НомерЭлементаЛевая,
		|	ТаблицаПравая.Номер КАК НомерЭлементаПравая,
		|	ВЫБОР
		|		КОГДА ТаблицаПравая.Номер - ТаблицаЛевая.Номер < 0
		|			ТОГДА ТаблицаЛевая.Номер - ТаблицаПравая.Номер
		|		ИНАЧЕ ТаблицаПравая.Номер - ТаблицаЛевая.Номер
		|	КОНЕЦ КАК РасстояниеОтНачала,
		|	ВЫБОР
		|		КОГДА &КоличествоСтрокПравая - ТаблицаПравая.Номер - (&КоличествоСтрокЛевая - ТаблицаЛевая.Номер) < 0
		|			ТОГДА &КоличествоСтрокЛевая - ТаблицаЛевая.Номер - (&КоличествоСтрокПравая - ТаблицаПравая.Номер)
		|		ИНАЧЕ  &КоличествоСтрокПравая - ТаблицаПравая.Номер - (&КоличествоСтрокЛевая - ТаблицаЛевая.Номер)
		|	КОНЕЦ КАК РасстояниеОтКонца,
		|	СУММА(ВЫБОР
		|			КОГДА ТаблицаЛевая.Значение <> """"
		|				ТОГДА ВЫБОР
		|						КОГДА ТаблицаЛевая.Количество < ТаблицаПравая.Количество
		|							ТОГДА ТаблицаЛевая.Количество
		|						ИНАЧЕ ТаблицаПравая.Количество
		|					КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоСовпаденийЗначений,
		|	СУММА(ВЫБОР
		|			КОГДА ТаблицаЛевая.Количество < ТаблицаПравая.Количество
		|				ТОГДА ТаблицаЛевая.Количество
		|			ИНАЧЕ ТаблицаПравая.Количество
		|		КОНЕЦ) КАК КоличествоСовпаденийВсего
		|ПОМЕСТИТЬ ДанныеСвернуто
		|ИЗ
		|	ТаблицаЛевая КАК ТаблицаЛевая
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПравая КАК ТаблицаПравая
		|		ПО ТаблицаЛевая.Значение = ТаблицаПравая.Значение
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаЛевая.Номер,
		|	ТаблицаПравая.Номер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеСвернуто.НомерЭлементаЛевая КАК НомерЭлементаЛевая,
		|	ДанныеСвернуто.НомерЭлементаПравая КАК НомерЭлементаПравая,
		|	ДанныеСвернуто.КоличествоСовпаденийЗначений КАК КоличествоСовпаденийЗначений,
		|	ДанныеСвернуто.КоличествоСовпаденийВсего КАК КоличествоСовпаденийВсего,
		|	ВЫБОР
		|		КОГДА ДанныеСвернуто.РасстояниеОтНачала < ДанныеСвернуто.РасстояниеОтКонца
		|			ТОГДА ДанныеСвернуто.РасстояниеОтНачала
		|		ИНАЧЕ ДанныеСвернуто.РасстояниеОтКонца
		|	КОНЕЦ КАК МинимальноеРасстояние
		|ИЗ
		|	ДанныеСвернуто КАК ДанныеСвернуто
		|
		|УПОРЯДОЧИТЬ ПО
		|	КоличествоСовпаденийЗначений УБЫВ,
		|	КоличествоСовпаденийВсего УБЫВ,
		|	МинимальноеРасстояние,
		|	НомерЭлементаЛевая,
		|	НомерЭлементаПравая";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДанныеИзТаблицыЛевая", ДанныеИзТаблицыЛевая);
	Запрос.УстановитьПараметр("ДанныеИзТаблицыПравая", ДанныеИзТаблицыПравая);
	Запрос.УстановитьПараметр("КоличествоСтрокЛевая", ТаблицаЛевая.Количество());
	Запрос.УстановитьПараметр("КоличествоСтрокПравая", ТаблицаПравая.Количество());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если РезультатСоответствияЛевая[Выборка.НомерЭлементаЛевая].Значение = Неопределено
			И РезультатСоответствияПравая[Выборка.НомерЭлементаПравая].Значение = Неопределено Тогда
				РезультатСоответствияЛевая[Выборка.НомерЭлементаЛевая].Значение = Выборка.НомерЭлементаПравая;
				РезультатСоответствияПравая[Выборка.НомерЭлементаПравая].Значение = Выборка.НомерЭлементаЛевая;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Массив;
	Результат.Добавить(РезультатСоответствияЛевая);
	Результат.Добавить(РезультатСоответствияПравая);
	
	Возврат Результат;

КонецФункции

&НаСервере
Функция ПолучитьДанныеДляСравнения(ТаблицаЗначенийИсточник, ПоСтрокам)
	
	МаксимальныйРазмерСтрок = Новый КвалификаторыСтроки(100);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Номер",		Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Значение",	Новый ОписаниеТипов("Строка",,,,МаксимальныйРазмерСтрок));
	
	Граница1 = ?(ПоСтрокам, ТаблицаЗначенийИсточник.Количество(),
							ТаблицаЗначенийИсточник.Колонки.Количество()) - 1;
		
	Граница2 = ?(ПоСтрокам, ТаблицаЗначенийИсточник.Колонки.Количество(),
							ТаблицаЗначенийИсточник.Количество()) - 1;
		
	Для Индекс1 = 0 По Граница1 Цикл
		
		Для Индекс2 = 0 По Граница2 Цикл
			
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Номер = Индекс1+1;
			НоваяСтрока.Значение = ?(ПоСтрокам, ТаблицаЗначенийИсточник[Индекс1][Индекс2],
												ТаблицаЗначенийИсточник[Индекс2][Индекс1]);
			
		КонецЦикла;
		
	КонецЦикла;

	Результат.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	Результат.ЗаполнитьЗначения(1, "Количество");
	
	Результат.Свернуть("Номер, Значение", "Количество");
	
	Возврат Результат;
		
КонецФункции


&НаКлиенте
Процедура ОбработатьАктивизациюОбласти(ТабДокИсточник, ТабДокПриемник, СоответствияИсточник, СоответствияПриемник)
	
	БлокировкаОбработкиАктивизации = Истина;
	
	ТекОбласть = ТабДокИсточник.Элемент.ТекущаяОбласть;
	
	Если ТекОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Таблица Тогда
		
		ВыбраннаяОбласть = ТабДокПриемник.Область();
		
	Иначе
	
		Если ТекОбласть.Низ < СоответствияИсточник.Строки.Количество() Тогда
			НомерСтроки = СоответствияИсточник.Строки[ТекОбласть.Низ].Значение;
		Иначе
			НомерСтроки = ТекОбласть.Низ 
							- СоответствияИсточник.Строки.Количество()
								+ СоответствияПриемник.Строки.Количество();
		КонецЕсли;
		
		Если ТекОбласть.Лево < СоответствияИсточник.Столбцы.Количество() Тогда
			НомерСтолбца = СоответствияИсточник.Столбцы[ТекОбласть.Лево].Значение;
		Иначе
			НомерСтолбца = ТекОбласть.Лево
							- СоответствияИсточник.Столбцы.Количество()
								+ СоответствияПриемник.Столбцы.Количество();
		КонецЕсли;
		
		
		ВыбраннаяОбласть = Неопределено;
		
		Если ТекОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
					
			Если НомерСтроки <> Неопределено И НомерСтолбца <> Неопределено Тогда
				ВыбраннаяОбласть = ТабДокПриемник.Объект.Область(НомерСтроки, НомерСтолбца);
			КонецЕсли;
					
		ИначеЕсли ТекОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			
			Если НомерСтроки <> Неопределено Тогда
				ВыбраннаяОбласть = ТабДокПриемник.Объект.Область(НомерСтроки, 0, НомерСтроки, 0);
			КонецЕсли;
			
		ИначеЕсли ТекОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
			
			Если НомерСтолбца <> Неопределено Тогда
				ВыбраннаяОбласть = ТабДокПриемник.Объект.Область(0, НомерСтолбца, 0, НомерСтолбца);
			КонецЕсли;
			
		Иначе		
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТабДокПриемник.Элемент.ТекущаяОбласть = ВыбраннаяОбласть;
	
	БлокировкаОбработкиАктивизации = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущееИзменение(ЭлементФормы, РеквизитФормы, ТаблицаРазличий)
	
	Перем Индекс;
	
	ТекЯчейка = ЭлементФормы.ТекущаяОбласть;
	НомерСтроки = ТекЯчейка.Верх;
	НомерСтолбца = ТекЯчейка.Лево;
	Для Каждого ТекСтрока Из ТаблицаРазличий Цикл
		Если ТекСтрока.НомерСтроки < НомерСтроки 
			ИЛИ ТекСтрока.НомерСтроки = НомерСтроки И ТекСтрока.НомерСтолбца < НомерСтолбца Тогда
			Индекс = ТаблицаРазличий.Индекс(ТекСтрока);
		ИначеЕсли ТекСтрока.НомерСтроки >= НомерСтроки И ТекСтрока.НомерСтолбца > НомерСтолбца Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Индекс <> Неопределено Тогда
		СтрокаРазличий = ТаблицаРазличий[Индекс];
		НомерСтроки = СтрокаРазличий.НомерСтроки;
		НомерСтолбца = СтрокаРазличий.НомерСтолбца;
		ЭлементФормы.ТекущаяОбласть = РеквизитФормы.Область(НомерСтроки, НомерСтолбца, НомерСтроки, НомерСтолбца);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СледующееИзменение(ЭлементФормы, РеквизитФормы, ТаблицаРазличий)
	
	Перем Индекс;
	
	ТекЯчейка = ЭлементФормы.ТекущаяОбласть;
	НомерСтроки = ТекЯчейка.Верх;
	НомерСтолбца = ТекЯчейка.Лево;
	Для Каждого ТекСтрока Из ТаблицаРазличий Цикл
		Если ТекСтрока.НомерСтроки = НомерСтроки И ТекСтрока.НомерСтолбца > НомерСтолбца 
			ИЛИ ТекСтрока.НомерСтроки > НомерСтроки Тогда
			Индекс = ТаблицаРазличий.Индекс(ТекСтрока);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Индекс <> Неопределено Тогда
		СтрокаРазличий = ТаблицаРазличий[Индекс];
		НомерСтроки = СтрокаРазличий.НомерСтроки;
		НомерСтолбца = СтрокаРазличий.НомерСтолбца;
		ЭлементФормы.ТекущаяОбласть = РеквизитФормы.Область(НомерСтроки, НомерСтолбца, НомерСтроки, НомерСтолбца);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти