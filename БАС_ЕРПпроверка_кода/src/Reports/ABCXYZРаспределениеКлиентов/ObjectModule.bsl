#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	Параметры = ЭтаФорма.Параметры;
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	Если НЕ (Параметры.Свойство("Расшифровка") И Параметры.Расшифровка = Неопределено) Тогда
		ПараметрыРасшифровки = Параметры.Расшифровка;
		ПрименяемыеНастройки = КомпоновщикНастроекФормы.ФиксированныеНастройки;

		// Установить параметры данных
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ТекущийПериод", ПараметрыРасшифровки.ТекущийПериод);
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ТипПараметраКлассификации", ПараметрыРасшифровки.ТипПараметраКлассификации);

		// Установить отбор
		ОтборРасшифровки = ПрименяемыеНастройки.Отбор;
		Если ПараметрыРасшифровки.Свойство("Вопросы") Тогда
			ПолеXYZ = Новый ПолеКомпоновкиДанных("КлассXYZ");
			ПолеABC = Новый ПолеКомпоновкиДанных("КлассABC");

			ГруппаОтбораНе = СоздатьГруппуОтбора(ОтборРасшифровки, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе);
			ГруппаОтбораИли = СоздатьГруппуОтбора(ГруппаОтбораНе, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			ГруппаОтбораИ = СоздатьГруппуОтбора(ГруппаОтбораИли, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			СоздатьЭлементОтбора(ГруппаОтбораИ, ПолеABC, Перечисления.ABCКлассификация.AКласс);
			ГруппаОтбораИлиXYZ = СоздатьГруппуОтбора(ГруппаОтбораИ, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			СоздатьЭлементОтбора(ГруппаОтбораИлиXYZ, ПолеXYZ, Перечисления.XYZКлассификация.XКласс);
			СоздатьЭлементОтбора(ГруппаОтбораИлиXYZ, ПолеXYZ, Перечисления.XYZКлассификация.ZКласс);
			ГруппаОтбораИ = СоздатьГруппуОтбора(ГруппаОтбораИли, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			СоздатьЭлементОтбора(ГруппаОтбораИ, ПолеABC, Перечисления.ABCКлассификация.CКласс);
			СоздатьЭлементОтбора(ГруппаОтбораИ, ПолеXYZ, Перечисления.XYZКлассификация.XКласс);
			СоздатьЭлементОтбора(ГруппаОтбораИли, ПолеXYZ, Перечисления.XYZКлассификация.НеКлассифицирован);
			СоздатьЭлементОтбора(ГруппаОтбораИли, ПолеXYZ, Перечисления.XYZКлассификация.ПустаяСсылка());
		Иначе
			Для Каждого Элемент Из ПараметрыРасшифровки.Отбор Цикл
				СоздатьЭлементОтбора(ОтборРасшифровки, 
					Новый ПолеКомпоновкиДанных(Элемент.Ключ), 
					Элемент.Значение);
			КонецЦикла;
		КонецЕсли;
		
		ПараметрыРасшифровки.Вставить("ПрименяемыеНастройки", ПрименяемыеНастройки);
	КонецЕсли;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	Параметры = ЭтаФорма.НастройкиОтчета;

	Если Параметры.Свойство("Расшифровка") И Параметры.Расшифровка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Установить заголовки
	ПараметрыРасшифровки = Параметры.Расшифровка;
	Настройки = Отчет.КомпоновщикНастроек.Настройки;
	Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("Заголовок", ПараметрыРасшифровки.Заголовок);
	Выбор = Настройки.Выбор.Элементы;
	ПолеТипПараметра = Новый ПолеКомпоновкиДанных("ЗначениеПараметраКлассификации");
	Для Каждого Элемент Из Выбор Цикл
		Если Элемент.Поле = ПолеТипПараметра Тогда
			Элемент.Заголовок = ПараметрыРасшифровки.ТипПараметраКлассификации;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьГруппуОтбора(Родитель, ТипГруппы)
	ГруппаОтбора = Родитель.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппы;
	ГруппаОтбора.Использование = Истина;
	
	Возврат ГруппаОтбора;
КонецФункции

Процедура СоздатьЭлементОтбора(Родитель, Поле, Значение)
	ЭлементОтбора = Родитель.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Поле;
	ЭлементОтбора.ПравоеЗначение = Значение;
	ЭлементОтбора.Использование  = Истина;
КонецПроцедуры

#КонецОбласти

#КонецЕсли