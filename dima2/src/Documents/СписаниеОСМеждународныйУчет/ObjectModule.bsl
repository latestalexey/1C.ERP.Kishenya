#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ОсновныеСредства.Добавить().ОсновноеСредство = ДанныеЗаполнения;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "ГруппаОСМеждународныйУчет"));
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.СписаниеОС") Тогда
		ЗаполнитьПоДокументуРеглУчета(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ОчиститьЗаписатьДвижения(Движения, "Международный, ОсновныеСредстваМеждународныйУчет");
	
	МеждународныйУчетВнеоборотныеАктивы.ПроверитьВозможностьСменыСостоянияОС(
		ЭтотОбъект,
		ОсновныеСредства.ВыгрузитьКолонку("ОсновноеСредство"),
		Перечисления.СостоянияОС.СнятоСУчета,
		Отказ);
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.СписаниеОСМеждународныйУчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение
	Для Каждого ТаблицаДвижений Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		ПроведениеСервер.ОтразитьДвижения(ТаблицаДвижений.Значение, Движения[ТаблицаДвижений.Ключ], Отказ);
	КонецЦикла;
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КлючевыеРеквизиты = Новый Массив;
	КлючевыеРеквизиты.Добавить("ОсновноеСредство");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(
		ЭтотОбъект, "ОсновныеСредства", КлючевыеРеквизиты, Отказ, НСтр("ru='Основные средства';uk='Основні засоби'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуРеглУчета(ДанныеЗаполнения)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДокументРегл.Ссылка КАК ДокументОснование,
		|	ДокументРегл.Организация КАК Организация,
		|	ДокументРегл.Подразделение КАК Подразделение,
		|	ДокументРегл.ОС.(
		|		ОсновноеСредство
		|	) КАК ТабличнаяЧасть
		|ИЗ
		|	Документ.СписаниеОС КАК ДокументРегл
		|ГДЕ
		|	ДокументРегл.Ссылка = &Ссылка"
	);
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
	ЭтотОбъект.ОсновныеСредства.Загрузить(Реквизиты.ТабличнаяЧасть.Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли