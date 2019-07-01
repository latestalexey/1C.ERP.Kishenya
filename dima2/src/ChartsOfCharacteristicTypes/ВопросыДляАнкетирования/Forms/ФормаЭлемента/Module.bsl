
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриИзмененииТипаОтвета();
	КонецЕсли;
	УправлениеВидимостью();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установим отбор по владельцу на динамическом списке справочника "Варианты ответов анкет".
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыОтветов,"Владелец", Объект.Ссылка, ВидСравненияКомпоновкиДанных.Равно, ,Истина);
	
	УстановитьТипОтвета();
	
	Если ТипОтвета = Перечисления.ТипыОтветовНаВопрос.Строка Тогда
		ДлинаСтроки = Объект.Длина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Число") Тогда
		
		Если Объект.МинимальноеЗначение > Объект.МаксимальноеЗначение Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Минимально допустимое значение не может быть больше чем максимальное.';uk='Мінімально допустиме значення не може бути більше ніж максимальне.'"),,
			                                                  "Объект.МинимальноеЗначение");
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Строка") Тогда	
		
		Объект.Длина = ДлинаСтроки;
		Если ДлинаСтроки = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено значение длины строки.';uk='Не заповнено значення довжини рядка.'"),,"ДлинаСтроки");
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Текст") Тогда
		
		Объект.Длина = 1024;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОтветаПриИзменении(Элемент)
	
	ПриИзмененииТипаОтвета();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДоступностьТаблицыВариантыОтветов();
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыОтветов,"Владелец", Объект.Ссылка, ВидСравненияКомпоновкиДанных.Равно, ,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВариантыОтветовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФормуЭлементаСправочникаВопросыОтветовАнкет(Элемент,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяКомментарийПриИзменении(Элемент)
	
	ДоступностьНеобходимостьПояснениеКомментария();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Формулировка) Тогда
	
		Объект.Формулировка = Объект.Наименование;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВариантыОтветовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьФормуЭлементаСправочникаВопросыОтветовАнкет(Элемент,Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВариантыОтветовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуЭлементаСправочникаВопросыОтветовАнкет(Элемент,Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаПриИзменении(Элемент)
	
	УстановитьТочностьВЗависимостиОтДлиныЧисла();
	
	ОтключитьОтметкуНезаполненного();
	
КонецПроцедуры

&НаКлиенте
Процедура ТочностьПриИзменении(Элемент)
	
	УстановитьТочностьВЗависимостиОтДлиныЧисла();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("РедактированиеФормулировкиПриЗакрытии", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(ОповещениеОЗакрытии, Элемент.ТекстРедактирования, НСтр("ru='Формулировка';uk='Формулювання'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(ВариантыОтветов, Элементы.ТаблицаВариантыОтветов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(ВариантыОтветов, Элементы.ТаблицаВариантыОтветов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Длина.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Длина");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТипОтвета");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОтветовНаВопрос.Строка;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТипОтвета");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОтветовНаВопрос.Число;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТипОтвета.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипОтвета");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОтветовНаВопрос.ЗначениеИнформационнойБазы;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

// Управляет видимостью страниц и элементов формы.
&НаКлиенте
Процедура УправлениеВидимостью()
	
	ВозможенКомментарий = НЕ (Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") 
	                        ИЛИ Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Текст"));
	Элементы.ТребуетсяКомментарий.Доступность  = ВозможенКомментарий;
	Элементы.Комментарий.Доступность           = ВозможенКомментарий;
	Если НЕ ВозможенКомментарий Тогда
		Объект.ТребуетсяКомментарий = Ложь;
		Объект.ПояснениеКомментария = "";
	КонецЕсли;
	ДоступностьНеобходимостьПояснениеКомментария();
	
	Если Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Строка") Тогда 
		
		Элементы.ЗависимыеПараметры.ТекущаяСтраница = Элементы.СтраницаСтрока;
		
	ИначеЕсли Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Число") Тогда
		
		Элементы.ЗависимыеПараметры.ТекущаяСтраница = Элементы.СтраницаЧисло;
		
	ИначеЕсли Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ЗначениеИнформационнойБазы") Тогда
		
		Элементы.ЗависимыеПараметры.ТекущаяСтраница = Элементы.Пустая;
	
	ИначеЕсли Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ОдинВариантИз") 
	      ИЛИ Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") Тогда
		
		Элементы.ЗависимыеПараметры.ТекущаяСтраница = Элементы.ВариантыОтветов; 
		
		ДоступностьТаблицыВариантыОтветов();
		
	Иначе
		
		Элементы.ЗависимыеПараметры.ТекущаяСтраница = Элементы.Пустая;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииТипаОтвета()

	Если ТипЗнч(ТипОтвета) = Тип("ПеречислениеСсылка.ТипыОтветовНаВопрос") Тогда
		
		Объект.ТипОтвета = ТипОтвета;
		
	ИначеЕсли ТипЗнч(ТипОтвета) = Тип("ОписаниеТипов") Тогда
		
		Объект.ТипОтвета   = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ЗначениеИнформационнойБазы");
		Объект.ТипЗначения = ТипОтвета;
		
	КонецЕсли;
	
	УправлениеВидимостью();
	
	Если Объект.ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Число") Тогда
		УстановитьТочностьВЗависимостиОтДлиныЧисла();
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ДоступностьНеобходимостьПояснениеКомментария()
	
	Элементы.ПояснениеКомментария.АвтоОтметкаНезаполненного = Объект.ТребуетсяКомментарий;
	Элементы.ПояснениеКомментария.ТолькоПросмотр            = НЕ Объект.ТребуетсяКомментарий;
	
	ОтключитьОтметкуНезаполненного();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьТаблицыВариантыОтветов()
	
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.ТаблицаВариантыОтветов.ТолькоПросмотр  = Истина;
		ИнформацияВариантыОтветов                       = НСтр("ru='Для редактирования вариантов ответов необходимо записать вопрос для анкетирования';uk='Для редагування варіантів відповідей необхідно записати питання для анкетування'");
	Иначе
		Элементы.ТаблицаВариантыОтветов.ТолькоПросмотр = Ложь;
		ИнформацияВариантыОтветов                      = НСтр("ru='Варианты ответов на вопрос:';uk='Варіанти відповідей на питання:'");
	КонецЕсли; 
	
	Если ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ОдинВариантИз") Тогда
		Элементы.ТребуетОткрытогоОтвета.Видимость = Ложь;
	ИначеЕсли ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") Тогда
		Элементы.ТребуетОткрытогоОтвета.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЭлементаСправочникаВопросыОтветовАнкет(Элемент,РежимДобавления)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Владелец",Объект.Ссылка);
	СтруктураПараметров.Вставить("ТипОтвета",Объект.ТипОтвета);
	
	Если Не РежимДобавления Тогда
		ТекущиеДанные = Элементы.ТаблицаВариантыОтветов.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.Ссылка);
	КонецЕсли;
		
	ОткрытьФорму("Справочник.ВариантыОтветовАнкет.Форма.ФормаЭлемента",СтруктураПараметров,Элемент);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипОтвета()
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ТипыОтветовНаВопрос.ЗначенияПеречисления Цикл
		
		Если Перечисления.ТипыОтветовНаВопрос[ЗначениеПеречисления.Имя] = Перечисления.ТипыОтветовНаВопрос.ЗначениеИнформационнойБазы Тогда 
			
			Для каждого ДоступныйТип Из РеквизитФормыВЗначение("Объект").Метаданные().Тип.Типы() Цикл
				
				Если ДоступныйТип = Тип("Строка") ИЛИ ДоступныйТип = Тип("Булево") ИЛИ ДоступныйТип = Тип("Число") ИЛИ ДоступныйТип = Тип("Дата") ИЛИ ДоступныйТип = Тип("СправочникСсылка.ВариантыОтветовАнкет") Тогда
					Продолжить;
				КонецЕсли;
				
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(ДоступныйТип);
				Элементы.ТипОтвета.СписокВыбора.Добавить(Новый ОписаниеТипов(МассивТипов));
				
			КонецЦикла;
			
		Иначе
			Элементы.ТипОтвета.СписокВыбора.Добавить(Перечисления.ТипыОтветовНаВопрос[ЗначениеПеречисления.Имя]);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Объект.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.ЗначениеИнформационнойБазы Тогда
		
		ТипОтвета = Объект.ТипЗначения;
		
	ИначеЕсли Объект.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.ПустаяСсылка() Тогда
		
		ТипОтвета = Элементы.ТипОтвета.СписокВыбора[0].Значение;
		
	Иначе
		
		ТипОтвета = Объект.ТипОтвета;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает точность числового ответа в зависимости от выбранной длины.
//
&НаКлиенте
Процедура УстановитьТочностьВЗависимостиОтДлиныЧисла()

	Если Объект.Длина > 15 Тогда
		Объект.Длина = 15;
	КонецЕсли;
	
	Если Объект.Длина = 0 Тогда
		Объект.Точность = 0;
	ИначеЕсли Объект.Длина <= Объект.Точность Тогда
		Объект.Точность = Объект.Длина - 1;
	КонецЕсли;
	
	Если Объект.Точность > 3 Тогда
		Объект.Точность = 3;
	КонецЕсли;
	
	Если (Объект.Длина - Объект.Точность) > 12 Тогда
		Объект.Длина = Объект.Точность + 12;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеФормулировкиПриЗакрытии(ТекстВозврата, ДополнительныеПараметры) Экспорт
	
	Если Объект.Формулировка <> ТекстВозврата Тогда
		Объект.Формулировка = ТекстВозврата;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
