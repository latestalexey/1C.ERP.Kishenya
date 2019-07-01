#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		НематериальныйАктив = ДанныеЗаполнения;
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
	
	ПроведениеСервер.ОчиститьЗаписатьДвижения(Движения, "Международный, НематериальныеАктивыМеждународныйУчет");
	
	ПроверитьВозможностьПроведения(Отказ);
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПеремещениеНМАМеждународныйУчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

Процедура ПроверитьВозможностьПроведения(Отказ=Ложь)
	
	ТребуемоеСостояние = Новый Структура(
		"Организация, Состояние, Подразделение",
		Организация, Перечисления.ВидыСостоянийНМА.ПринятКУчету, Подразделение);
	ПараметрыПроверки = Новый Структура("ДатаСведений, ИсключаемыйРегистратор", Дата, Ссылка);
	Ошибки = МеждународныйУчетВнеоборотныеАктивы.ПроверитьСостояниеВнеоборотныхАктивов(
		НематериальныйАктив, ТребуемоеСостояние, ПараметрыПроверки);
	Если Ошибки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Ошибки Цикл
		Объект = КлючИЗначение.Ключ;
		Данные = КлючИЗначение.Значение;
		
		ТекстОшибки = НСтр("ru='Учетные данные нематериального актива ""%1"" не могут быть изменены.';uk='Облікові дані нематеріального активу ""%1"" не можуть бути змінені.'") + Символы.ПС;
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", Объект);
		Если Данные.Состояние <> Перечисления.ВидыСостоянийНМА.ПринятКУчету Тогда
			ТекстОшибки = ТекстОшибки
				+ НСтр("ru='Объект не принят к учету';uk='Об''єкт не прийнятий до обліку'");
		Иначе
			Шаблон = НСтр("ru='Объект принят к учету в организации ""%1"" в подразделение ""%2""';uk='Об''єкт прийнято до обліку в організації ""%1"" в підрозділ ""%2""'");
			ТекстОшибки = ТекстОшибки
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Данные.Организация, Данные.Подразделение);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НематериальныйАктив",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли