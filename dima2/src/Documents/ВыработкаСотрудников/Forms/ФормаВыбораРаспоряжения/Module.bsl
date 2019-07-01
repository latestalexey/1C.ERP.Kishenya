
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонЗаголовка = НСтр("ru='Распоряжения на оформление (%1)';uk='Розпорядження на оформлення (%1)'");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, Параметры.ВидРабот);
	
	//++ НЕ УТКА
	Список.ТекстЗапроса = ТекстЗапросаДинамическогоСписка();
	
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка",			Параметры.Ссылка);
	Список.Параметры.УстановитьЗначениеПараметра("ВидРабот",		Параметры.ВидРабот);
	Список.Параметры.УстановитьЗначениеПараметра("Организация",		Параметры.Организация);
	Список.Параметры.УстановитьЗначениеПараметра("Бригада",			Параметры.Бригада);
	Список.Параметры.УстановитьЗначениеПараметра("ВидНаряда",		Параметры.ВидНаряда);
	//-- НЕ УТКА
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураВыбора = Новый Структура();
		
		СтруктураВыбора.Вставить("Распоряжение",			ТекущиеДанные.Распоряжение);
		СтруктураВыбора.Вставить("КодСтрокиРаспоряжения",	ТекущиеДанные.КодСтрокиРаспоряжения);
		СтруктураВыбора.Вставить("СтатьяКалькуляции",		ТекущиеДанные.СтатьяКалькуляции);
		СтруктураВыбора.Вставить("СтатьяРасходов",			ТекущиеДанные.СтатьяРасходов);
		СтруктураВыбора.Вставить("АналитикаРасходов",		ТекущиеДанные.АналитикаРасходов);
		СтруктураВыбора.Вставить("Количество",				ТекущиеДанные.Количество);
		
		ОповеститьОВыборе(СтруктураВыбора);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитикаРасходов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.АналитикаРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатьяРасходов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатьяРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатьяКалькуляции.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатьяКалькуляции");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

//++ НЕ УТКА
&НаСервере
Функция ТекстЗапросаДинамическогоСписка()
	
	Возврат
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Распоряжение,
	|	ВложенныйЗапрос.КодСтрокиРаспоряжения,
	|	ВложенныйЗапрос.ВидРабот,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	|	ВложенныйЗапрос.СтатьяКалькуляции,
	|	ВложенныйЗапрос.АналитикаРасходов,
	|	ВложенныйЗапрос.СтатьяРасходов,
	|	ВложенныйЗапрос.ВидНаряда
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТрудозатратыКОформлениюОстатки.Распоряжение КАК Распоряжение,
	|		ТрудозатратыКОформлениюОстатки.КодСтрокиРаспоряжения КАК КодСтрокиРаспоряжения,
	|		ТрудозатратыКОформлениюОстатки.ВидРабот КАК ВидРабот,
	|		ТрудозатратыКОформлениюОстатки.КоличествоОстаток КАК Количество,
	|		МаршрутныйЛистПроизводстваТрудозатраты.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|		"""" КАК АналитикаРасходов,
	|		"""" КАК СтатьяРасходов,
	|		ВЫБОР
	|			КОГДА ТрудозатратыКОформлениюОстатки.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|		КОНЕЦ КАК ВидНаряда
	|	ИЗ
	|		РегистрНакопления.ТрудозатратыКОформлению.Остатки(
	|				,
	|				Бригада = &Бригада
	|					И Организация = &Организация
	|					И ВидРабот = &ВидРабот) КАК ТрудозатратыКОформлениюОстатки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства.Трудозатраты КАК МаршрутныйЛистПроизводстваТрудозатраты
	|			ПО ТрудозатратыКОформлениюОстатки.Распоряжение = МаршрутныйЛистПроизводстваТрудозатраты.Ссылка
	|				И ТрудозатратыКОформлениюОстатки.КодСтрокиРаспоряжения = МаршрутныйЛистПроизводстваТрудозатраты.КодСтроки
	|	ГДЕ
	|		ТрудозатратыКОформлениюОстатки.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|		И ТрудозатратыКОформлениюОстатки.КоличествоОстаток > 0
	|		И ВЫБОР
	|				КОГДА ТрудозатратыКОформлениюОстатки.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|			КОНЕЦ = &ВидНаряда
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТрудозатратыКОформлениюОстатки.Распоряжение,
	|		ТрудозатратыКОформлениюОстатки.КодСтрокиРаспоряжения,
	|		ТрудозатратыКОформлениюОстатки.ВидРабот,
	|		ТрудозатратыКОформлениюОстатки.КоличествоОстаток,
	|		"""",
	|		ЗаказНаРемонтТрудозатраты.Ссылка.ОбъектЭксплуатации,
	|		ЗаказНаРемонтРемонты.СтатьяРасходов,
	|		ВЫБОР
	|			КОГДА ТрудозатратыКОформлениюОстатки.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТрудозатратыКОформлению.Остатки(
	|				,
	|				Бригада = &Бригада
	|					И Организация = &Организация
	|					И ВидРабот = &ВидРабот) КАК ТрудозатратыКОформлениюОстатки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаРемонт.Трудозатраты КАК ЗаказНаРемонтТрудозатраты
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаРемонт.Ремонты КАК ЗаказНаРемонтРемонты
	|				ПО ЗаказНаРемонтТрудозатраты.КодРемонта = ЗаказНаРемонтРемонты.КодРемонта
	|					И ЗаказНаРемонтТрудозатраты.Ссылка = ЗаказНаРемонтРемонты.Ссылка
	|			ПО ТрудозатратыКОформлениюОстатки.Распоряжение = ЗаказНаРемонтТрудозатраты.Ссылка
	|				И ТрудозатратыКОформлениюОстатки.КодСтрокиРаспоряжения = ЗаказНаРемонтТрудозатраты.КодСтроки
	|	ГДЕ
	|		ТрудозатратыКОформлениюОстатки.Распоряжение ССЫЛКА Документ.ЗаказНаРемонт
	|		И ВЫБОР
	|				КОГДА ТрудозатратыКОформлениюОстатки.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|			КОНЕЦ = &ВидНаряда
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТрудозатратыКОформлению.Распоряжение,
	|		ТрудозатратыКОформлению.КодСтрокиРаспоряжения,
	|		ТрудозатратыКОформлению.ВидРабот,
	|		ТрудозатратыКОформлению.Количество,
	|		МаршрутныйЛистПроизводстваТрудозатраты.СтатьяКалькуляции,
	|		"""",
	|		"""",
	|		ВЫБОР
	|			КОГДА ТрудозатратыКОформлению.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТрудозатратыКОформлению КАК ТрудозатратыКОформлению
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства.Трудозатраты КАК МаршрутныйЛистПроизводстваТрудозатраты
	|			ПО ТрудозатратыКОформлению.Распоряжение = МаршрутныйЛистПроизводстваТрудозатраты.Ссылка
	|				И ТрудозатратыКОформлению.КодСтрокиРаспоряжения = МаршрутныйЛистПроизводстваТрудозатраты.КодСтроки
	|	ГДЕ
	|		ТрудозатратыКОформлению.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|		И ВЫБОР
	|				КОГДА ТрудозатратыКОформлению.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|			КОНЕЦ = &ВидНаряда
	|		И ТрудозатратыКОформлению.Регистратор = &Ссылка
	|		И ТрудозатратыКОформлению.Бригада = &Бригада
	|		И ТрудозатратыКОформлению.ВидРабот = &ВидРабот
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТрудозатратыКОформлению.Распоряжение,
	|		ТрудозатратыКОформлению.КодСтрокиРаспоряжения,
	|		ТрудозатратыКОформлению.ВидРабот,
	|		ТрудозатратыКОформлению.Количество,
	|		"""",
	|		ЗаказНаРемонтТрудозатраты.Ссылка.ОбъектЭксплуатации,
	|		ЗаказНаРемонтРемонты.СтатьяРасходов,
	|		ВЫБОР
	|			КОГДА ТрудозатратыКОформлению.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТрудозатратыКОформлению КАК ТрудозатратыКОформлению
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаРемонт.Трудозатраты КАК ЗаказНаРемонтТрудозатраты
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаРемонт.Ремонты КАК ЗаказНаРемонтРемонты
	|				ПО ЗаказНаРемонтТрудозатраты.КодРемонта = ЗаказНаРемонтРемонты.КодРемонта
	|					И ЗаказНаРемонтТрудозатраты.Ссылка = ЗаказНаРемонтРемонты.Ссылка
	|			ПО ТрудозатратыКОформлению.Распоряжение = ЗаказНаРемонтТрудозатраты.Ссылка
	|				И ТрудозатратыКОформлению.КодСтрокиРаспоряжения = ЗаказНаРемонтТрудозатраты.КодСтроки
	|	ГДЕ
	|		ТрудозатратыКОформлению.Распоряжение ССЫЛКА Документ.ЗаказНаРемонт
	|		И ВЫБОР
	|				КОГДА ТрудозатратыКОформлению.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Производство)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыБригадныхНарядов.Ремонт)
	|			КОНЕЦ = &ВидНаряда
	|		И ТрудозатратыКОформлению.Регистратор = &Ссылка
	|		И ТрудозатратыКОформлению.ВидРабот = &ВидРабот
	|		И ТрудозатратыКОформлению.Бригада = &Бригада) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ВидРабот,
	|	ВложенныйЗапрос.СтатьяРасходов,
	|	ВложенныйЗапрос.Распоряжение,
	|	ВложенныйЗапрос.СтатьяКалькуляции,
	|	ВложенныйЗапрос.ВидНаряда,
	|	ВложенныйЗапрос.АналитикаРасходов,
	|	ВложенныйЗапрос.КодСтрокиРаспоряжения";
	
КонецФункции
//-- НЕ УТКА

#КонецОбласти
