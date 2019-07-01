
#Область ПрограммныйИнтерфейс

#Область ЗаказыПоставщикам

Функция ПроверитьВозможностьВводаНаОсновании(ПараметрКоманды) Экспорт
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрКоманды,"Статус,Проведен");
	
	Документы.ЗаказКлиента.ПроверитьВозможностьВводаНаОсновании(
		ПараметрКоманды,
		СтруктураРеквизитов.Статус,
		НЕ СтруктураРеквизитов.Проведен,
		Истина);
	
КонецФункции

#КонецОбласти

#Область ДокументыНаОснованииЗаказа

Функция АктВыполненныхРаботПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	
	Если ПараметрКоманды.Количество() = 1
	 ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам") Тогда
		
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды[0]);
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ПродажиВызовСервера.СформироватьДанныеЗаполненияАктовВыполненныхРабот(ПараметрКоманды, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

Функция ВнутреннееПотреблениеТоваровПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ТекстОшибки = "";
	Если ПараметрКоманды.Количество() = 1
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееПотреблениеПоНесколькимЗаказам") Тогда
		
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(ПараметрКоманды[0]);
		РеквизитыШапки = Документы.ВнутреннееПотреблениеТоваров.ДанныеЗаполненияНакладной(МассивЗаказов);
		ТекстОшибки = НакладныеСервер.ПроверитьВозможностьВводаВнутреннегоПотребленияНаОснованииЗаказа(ПараметрКоманды[0], РеквизитыШапки);
		
	Иначе
		
		МассивЗаказов = ПараметрКоманды;
		РеквизитыШапки = Документы.ВнутреннееПотреблениеТоваров.ДанныеЗаполненияНакладной(МассивЗаказов);
		
	КонецЕсли;
	
	Если ТекстОшибки <> "" Тогда
		РезультатыПроверки = Новый Структура("ЕстьОшибки, ТекстОшибки", Истина, ТекстОшибки);
	Иначе
		РезультатыПроверки = Документы.ВнутреннееПотреблениеТоваров.ПроверитьДанныеЗаполненияНакладной(РеквизитыШапки);
	КонецЕсли;
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("РеквизитыШапки", РеквизитыШапки);
	ПараметрыОснования.Вставить("МассивЗаказов",  МассивЗаказов);
	
	Возврат Новый Структура("Основание, РезультатыПроверки", ПараметрыОснования, РезультатыПроверки);
	
КонецФункции

Функция ПоступлениеТоваровУслугПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладПоступления",  Неопределено);
	
	Если ПараметрКоманды.Количество() = 1
	 ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды[0]);
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ЗакупкиВызовСервера.СформироватьДанныеЗаполненияПоступления(ПараметрКоманды, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

Функция СборкаТоваровПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ТекстОшибки = "";
	МассивЗаказов = Новый Массив();
	МассивЗаказов.Добавить(ПараметрКоманды[0]);
	РеквизитыШапки = Документы.СборкаТоваров.ДанныеЗаполненияНакладной(МассивЗаказов);
	ТекстОшибки = НакладныеСервер.ПроверитьВозможностьВводаСборкиНаОснованииЗаказа(ПараметрКоманды[0], РеквизитыШапки);
	
	Если ТекстОшибки <> "" Тогда
		РезультатыПроверки = Новый Структура("ЕстьОшибки, ТекстОшибки", Истина, ТекстОшибки);
	Иначе
		РезультатыПроверки = Документы.СборкаТоваров.ПроверитьДанныеЗаполненияНакладной(РеквизитыШапки);
	КонецЕсли;
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("РеквизитыШапки", РеквизитыШапки);
	ПараметрыОснования.Вставить("МассивЗаказов",  МассивЗаказов);
	Возврат Новый Структура("Основание, РезультатыПроверки", ПараметрыОснования, РезультатыПроверки);
	
КонецФункции

#КонецОбласти 

#Область РеализацияТоваровУслуг

Функция РеализацияТоваровУслугПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладОтгрузки", 			Неопределено);
	ПараметрыОснования.Вставить("ВариантОформленияПродажи", Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг);
	
	Если ПараметрКоманды.Количество() = 1
	 ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам") Тогда
		
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды[0]);
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ПродажиВызовСервера.СформироватьДанныеЗаполненияРеализации(ПараметрКоманды, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",      РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование",   ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

#КонецОбласти

#Область СчетНаОплату

Функция СчетНаОплатуРеализацияАктПолучитьПараметрыОткрытияФормы(Основание) Экспорт
	
	ПараметрыОткрытияФормы = Неопределено;
	
	МассивЗаказов = СчетНаОплатуРеализацияАктПолучитьЗаказыРеализацииСервер(Основание);
	
	Если СчетНаОплатуРеализацияАктПроверитьПорядокРасчетов(Основание)
	 ИЛИ МассивЗаказов.Количество() = 0 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаДокумента");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("Основание", Основание));
		
	ИначеЕсли МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("ДокументОснование", МассивЗаказов[0]));
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

Функция СчетНаОплатуРеализацияАктПроверитьПорядокРасчетов(Основание)
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ПорядокРасчетов");
	
	Возврат ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
	
КонецФункции 

Функция СчетНаОплатуРеализацияАктПолучитьЗаказыРеализацииСервер(Основание)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеализацияТоваровУслугТовары.ЗаказКлиента КАК ЗаказКлиента
		|ПОМЕСТИТЬ
		|	Заказы
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.Ссылка = &Основание
		|	И РеализацияТоваровУслугТовары.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
		|	И РеализацияТоваровУслугТовары.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|	И РеализацияТоваровУслугТовары.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РеализацияТоваровУслуг.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Ссылка = &Основание
		|	И РеализацияТоваровУслуг.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
		|	И РеализацияТоваровУслуг.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|	И РеализацияТоваровУслуг.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктВыполненныхРаботУслуги.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Документ.АктВыполненныхРабот.Услуги КАК АктВыполненныхРаботУслуги
		|ГДЕ
		|	АктВыполненныхРаботУслуги.Ссылка = &Основание
		|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
		|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	АктВыполненныхРабот.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК АктВыполненныхРабот
		|ГДЕ
		|	АктВыполненныхРабот.Ссылка = &Основание
		|	И АктВыполненныхРабот.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
		|	И АктВыполненныхРабот.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|	И АктВыполненныхРабот.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Заказы.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Заказы КАК Заказы
		|");
		
	Запрос.УстановитьПараметр("Основание", Основание);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивЗаказов = РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	Возврат МассивЗаказов;
	
КонецФункции

Функция СчетНаОплатуПоДоговоруПроверитьВозможностьСозданияСчетовНаОплату(Договор) Экспорт
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокРасчетов");
	Возврат ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	
КонецФункции

//++ НЕ УТКА

Функция СчетНаОплатуОтчетДавальцуПолучитьПараметрыОткрытияФормы(ОтчетДавальцу) Экспорт
	
	ПараметрыОткрытияФормы = Неопределено;
	
	МассивЗаказов = СчетНаОплатуОтчетДавальцуПолучитьЗаказыОтчетаДавальцуСервер(ОтчетДавальцу);
	
	Если СчетНаОплатуОтчетДавальцуПроверитьПорядокРасчетов(ОтчетДавальцу)
		ИЛИ МассивЗаказов.Количество() = 0 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаДокумента");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("Основание", ОтчетДавальцу));
		
	ИначеЕсли МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("ДокументОснование", МассивЗаказов[0]));
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

Функция СчетНаОплатуОтчетДавальцуПроверитьПорядокРасчетов(ОтчетДавальцу)
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтчетДавальцу, "ПорядокРасчетов");
	
	Возврат ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
	
КонецФункции

Функция СчетНаОплатуОтчетДавальцуПолучитьЗаказыОтчетаДавальцуСервер(ОтчетДавальцу)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОтчетДавальцуУслуги.ЗаказДавальца КАК ЗаказКлиента
		|ПОМЕСТИТЬ
		|	Заказы
		|ИЗ
		|	Документ.ОтчетДавальцу.Продукция КАК ОтчетДавальцуУслуги
		|ГДЕ
		|	ОтчетДавальцуУслуги.Ссылка = &ОтчетДавальцу
		|	И ОтчетДавальцуУслуги.ЗаказДавальца <> НЕОПРЕДЕЛЕНО
		|	И ОтчетДавальцуУслуги.ЗаказДавальца <> ЗНАЧЕНИЕ(Документ.ЗаказДавальца.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОтчетДавальцу.ЗаказДавальца КАК ЗаказКлиента
		|ИЗ
		|	Документ.ОтчетДавальцу КАК ОтчетДавальцу
		|ГДЕ
		|	ОтчетДавальцу.Ссылка = &ОтчетДавальцу
		|	И ОтчетДавальцу.ЗаказДавальца <> НЕОПРЕДЕЛЕНО
		|	И ОтчетДавальцу.ЗаказДавальца <> ЗНАЧЕНИЕ(Документ.ЗаказДавальца.ПустаяСсылка)
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Заказы.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Заказы КАК Заказы
		|");
		
	Запрос.УстановитьПараметр("ОтчетДавальцу", ОтчетДавальцу);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивЗаказов = РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	Возврат МассивЗаказов;
	
КонецФункции

Функция ВыпускПродукцииПараметрыОформленияВыпуска(МассивСсылок, ТекстПредупреждения) Экспорт

	Если МассивСсылок.Количество() > 1 И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВыпускПоНесколькимРаспоряжениям") Тогда
		ТекстПредупреждения = НСтр("ru='Оформление одного документа на основании нескольких маршрутных листов отключено.
                                            |Необходимо выбрать один маршрутный лист.'
                                            |;uk='Оформлення одного документа на підставі кількох маршрутних листів відключено.
                                            |Необхідно вибрати один маршрутний лист.'");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Документы.ВыпускПродукции.ПараметрыОформленияВыпуска(МассивСсылок,, ТекстПредупреждения);

КонецФункции

//-- НЕ УТКА

#КонецОбласти

Функция ПеремещениеТоваровПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ТекстОшибки = "";
	Если ПараметрКоманды.Количество() = 1
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеПоНесколькимЗаказам") Тогда
		
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(ПараметрКоманды[0]);
		РеквизитыШапки = Документы.ПеремещениеТоваров.ДанныеЗаполненияНакладной(МассивЗаказов);
		ТекстОшибки = НакладныеСервер.ПроверитьВозможностьВводаПеремещенияНаОснованииЗаказа(ПараметрКоманды[0], РеквизитыШапки);
		
	Иначе
		
		МассивЗаказов = ПараметрКоманды;
		РеквизитыШапки = Документы.ПеремещениеТоваров.ДанныеЗаполненияНакладной(МассивЗаказов);
		
	КонецЕсли;
	
	Если ТекстОшибки <> "" Тогда
		РезультатыПроверки = Новый Структура("ЕстьОшибки, ТекстОшибки", Истина, ТекстОшибки);
	Иначе
		РезультатыПроверки = Документы.ПеремещениеТоваров.ПроверитьДанныеЗаполненияНакладной(РеквизитыШапки);
	КонецЕсли;
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("РеквизитыШапки", РеквизитыШапки);
	ПараметрыОснования.Вставить("МассивЗаказов",  МассивЗаказов);
	Возврат Новый Структура("Основание, РезультатыПроверки", ПараметрыОснования, РезультатыПроверки);
	
КонецФункции


Функция ОписаниеКомандыСоздатьНаОсновании(ИмяКоманды, АдресКомандСоздатьНаОснованииВоВременномХранилище) Экспорт
	
	Возврат ВводНаОсновании.ОписаниеКомандыСоздатьНаОсновании(ИмяКоманды, АдресКомандСоздатьНаОснованииВоВременномХранилище);
	
КонецФункции

Функция ПроверитьСтатусПересчетаНаСервере(ПересчетСсылка) Экспорт
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("МожноОткрытьПомощник", Ложь);
	РезультатПроверки.Вставить("СообщениеПользователю", "");
	
	Статус = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПересчетСсылка, "Статус");
	Если Статус = Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда 
		РезультатПроверки.МожноОткрытьПомощник = Истина;
	Иначе
		СообщениеПользователю = НСтр("ru='Документ ""%ПересчетТоваров%"" находится в статусе ""%ТекущийСтатус%"". Воспользоваться помощником оформления складских актов можно только в статусе ""%СтатусВыполнено%"".';uk='Документ ""%ПересчетТоваров%"" знаходиться в статусі ""%ТекущийСтатус%"". Скористатися помічником оформлення складських актів можна тільки в статусі ""%СтатусВыполнено%"".'");
		СообщениеПользователю = СтрЗаменить(СообщениеПользователю, "%ПересчетТоваров%", ПересчетСсылка);
		СообщениеПользователю = СтрЗаменить(СообщениеПользователю, "%ТекущийСтатус%", Статус);
		СообщениеПользователю = СтрЗаменить(СообщениеПользователю, "%СтатусВыполнено%", Перечисления.СтатусыПересчетовТоваров.Выполнено);
		РезультатПроверки.СообщениеПользователю	= СообщениеПользователю;
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

//++ НЕ УТКА

Функция ВводКорректировкиДоступен(СписокЗаказов, ТекстПредупреждения) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказНаПроизводство.Ссылка
	|ИЗ
	|	Документ.ЗаказНаПроизводство КАК ЗаказНаПроизводство
	|ГДЕ
	|	ЗаказНаПроизводство.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Создан)
	|	И ЗаказНаПроизводство.Ссылка В(&СписокЗаказов)";
	
	Запрос.УстановитьПараметр("СписокЗаказов", СписокЗаказов);
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Если СписокЗаказов.Количество() = 1 Тогда
			ТекстПредупреждения = НСтр("ru='Корректировка доступна для заказа в статусах ""К производству"" и ""Закрыт"".';uk='Коригування доступне для замовлення в статусах ""До виробництва"" і ""Закрито"".'");
		Иначе
			ТекстПредупреждения = НСтр("ru='Корректировка доступна для заказов в статусах ""К производству"" и ""Закрыт"".';uk='Коригування доступне для замовлення в статусах ""До виробництва"" і ""Закрито"".'");
		КонецЕсли; 
		
		Возврат Ложь;
	КонецЕсли; 
	
	Возврат Истина;

КонецФункции

//-- НЕ УТКА

//++ НЕ УТ
Функция СписаниеЗатратНаВыпускПараметрыВводаНаОсновании(МассивВыпусков, ОбъектФормы) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(ВыпускПродукцииТовары.Ссылка.Дата, МЕСЯЦ) КАК Период,
	|	Остатки.Организация КАК Организация,
	|	ВыпускПродукцииТовары.Спецификация КАК Спецификация,
	|	Остатки.Назначение КАК Назначение,
	|	Остатки.Распоряжение,
	|	Остатки.КодСтроки КАК КодСтроки,
	|	Остатки.КоличествоОстаток КАК Количество,
	|	Остатки.Подразделение,
	|	Остатки.Номенклатура,
	|	Остатки.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СпецификацияВыходныеИзделия.НомерСтроки, 0) = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОсновноеИзделие,
	|	ВыпускПродукцииТовары.ТипСтоимости
	|ИЗ
	|	РегистрНакопления.РаспоряженияНаСписаниеПоНормативам.Остатки(, Распоряжение В (&МассивВыпусков)) КАК Остатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Товары КАК ВыпускПродукцииТовары
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК СпецификацияВыходныеИзделия
	|			ПО ВыпускПродукцииТовары.Спецификация = СпецификацияВыходныеИзделия.Ссылка
	|				И ВыпускПродукцииТовары.Номенклатура = СпецификацияВыходныеИзделия.Номенклатура
	|				И (ВыпускПродукцииТовары.Характеристика = СпецификацияВыходныеИзделия.Характеристика
	|					ИЛИ СпецификацияВыходныеИзделия.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ПО Остатки.Распоряжение = ВыпускПродукцииТовары.Ссылка
	|			И Остатки.КодСтроки = ВыпускПродукцииТовары.КодСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Организация,
	|	Спецификация,
	|	Назначение УБЫВ";
	
	Запрос.УстановитьПараметр("МассивВыпусков", МассивВыпусков);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	АвтоматическоеСоздание = Истина; // документы могут быть созданы автоматически если во всех распоряжениях заполнена спецификация
	НесколькоДокументов    = Ложь;
	ТекПериод              = Неопределено;
	ТекОрганизация         = Неопределено;
	ТекСпецификация        = Неопределено;
	ТекНазначение          = Неопределено;
	
	// данные шапки и распоряжения для заполнения нового документа, если автоматическое формирование невозможно
	ДанныеШапки = Новый Структура("Количество, Период, Организация, Подразделение, Номенклатура, Характеристика, Назначение, Спецификация", 0);
	ТаблицаРаспоряжений = Новый ТаблицаЗначений;
	ТаблицаРаспоряжений.Колонки.Добавить("Распоряжение",      Новый ОписаниеТипов("ДокументСсылка.ВыпускПродукции"));
	ТаблицаРаспоряжений.Колонки.Добавить("КодСтроки",         Новый ОписаниеТипов("Число"));
	
	ДанныеШапкиЗаполнены = Ложь;
	ПерваяИтерация = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		// если основное изделие не выбрано, то данные шапки будут заполнены по первому распоряжению
		Если ПерваяИтерация
			И Выборка.ТипСтоимости = Перечисления.ТипыСтоимостиВыходныхИзделий.Рассчитывается Тогда
			ЗаполнитьЗначенияСвойств(ДанныеШапки, Выборка, , "Количество");
			ПерваяИтерация = Ложь;
		КонецЕсли;
		
		// спецификация не указана, данные шапки заполняются по данному распоряжению
		Если Не ЗначениеЗаполнено(Выборка.Спецификация) Тогда
			ЗаполнитьЗначенияСвойств(ДанныеШапки, Выборка);
			ТаблицаРаспоряжений.Очистить();
			ЗаполнитьЗначенияСвойств(ТаблицаРаспоряжений.Добавить(), Выборка);
			АвтоматическоеСоздание = Ложь;
			Прервать;
		КонецЕсли;
		
		Если Выборка.ОсновноеИзделие И Не ДанныеШапкиЗаполнены Тогда
			ЗаполнитьЗначенияСвойств(ДанныеШапки, Выборка, , "Количество");
			ДанныеШапкиЗаполнены = Истина;
		КонецЕсли;
		
		Если ТекПериод = Неопределено Тогда
			ТекПериод = Выборка.Период;
		КонецЕсли;
		Если ТекОрганизация = Неопределено Тогда
			ТекОрганизация = Выборка.Организация;
		КонецЕсли;
		Если ТекСпецификация = Неопределено Тогда
			ТекСпецификация = Выборка.Спецификация;
		КонецЕсли;
		Если ТекНазначение = Неопределено Тогда
			ТекНазначение = Выборка.Назначение;
		КонецЕсли;
		
		Если ТекПериод <> Выборка.Период Или 
			ТекОрганизация <> Выборка.Организация Или
			ТекСпецификация <> Выборка.Спецификация Или
			(ТекНазначение <> Выборка.Назначение И ЗначениеЗаполнено(ТекНазначение) И ЗначениеЗаполнено(Выборка.Назначение)) Тогда
			НесколькоДокументов = Истина;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТаблицаРаспоряжений.Добавить(), Выборка);
		
	КонецЦикла;
	
	Результат = Новый Структура("ДанныеШапки, Распоряжения, СписокДокументов, ДанныеШапкиЗаполнены",
	ДанныеШапки,
	ПоместитьВоВременноеХранилище(ТаблицаРаспоряжений),
	Новый СписокЗначений,
	ДанныеШапкиЗаполнены);
	
	Если АвтоматическоеСоздание И НесколькоДокументов Тогда
		
		Параметры = Новый Структура("Распоряжения", ТаблицаРаспоряжений);
		
		ДокументыПоПараметрам = Документы.СписаниеЗатратНаВыпуск.ДокументыПоПараметрам(Параметры, Истина);
		
		Если ДокументыПоПараметрам.Свойство("ДокументОбъект") Тогда
			
			Результат.Вставить("ОткрытьФормуНового");
			
			ЗначениеВДанныеФормы(ДокументыПоПараметрам.ДокументОбъект, ОбъектФормы);
			
		Иначе
			Результат.СписокДокументов = ДокументыПоПараметрам.СписокДокументов;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СписаниеЗатратНаВыпускПроверитьОбъектыОснований(ПараметрКоманды) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(РаспоряженияНаСписаниеПоНормативамОстатки.КоличествоОстаток, 0) КАК Поле1
	|ИЗ
	|	РегистрНакопления.РаспоряженияНаСписаниеПоНормативам.Остатки КАК РаспоряженияНаСписаниеПоНормативамОстатки
	|ГДЕ
	|	РаспоряженияНаСписаниеПоНормативамОстатки.Распоряжение В(&Массив)
	|	И ЕСТЬNULL(РаспоряженияНаСписаниеПоНормативамОстатки.КоличествоОстаток, 0) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВыпускПродукции.ВыпускПоРаспоряжениям
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Поле1
	|ИЗ
	|	Документ.ВыпускПродукции КАК ВыпускПродукции
	|ГДЕ
	|	ВыпускПродукции.Ссылка В(&Массив)
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВыпускПродукции.ВыпускПоРаспоряжениям
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыпускПродукции.Ссылка
	|ИЗ
	|	Документ.ВыпускПродукции КАК ВыпускПродукции
	|ГДЕ
	|	ВыпускПродукции.Ссылка В(&Массив)
	|	И ВыпускПродукции.Подразделение.ИспользуетсяСписаниеЗатратНаВыпуск";
	
	Запрос.УстановитьПараметр("Массив", ПараметрКоманды);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Не Результат[0].Пустой() Тогда
		Возврат Неопределено;
	ИначеЕсли Результат[1].Пустой() Тогда
		Возврат НСтр("Ru = 'Списание затрат оформляется только по выпускам без заказа. Создание документа не требуется.'");
	ИначеЕсли Результат[2].Пустой() Тогда
		Возврат НСтр("Ru = 'Списание затрат на выпуск выбранных подразделений не используется. Создание документа не требуется.'");
	Иначе
		Возврат НСтр("Ru = 'По выбранным распоряжениям затраты уже списаны. Создание документа не требуется.'");
	КонецЕсли;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти
