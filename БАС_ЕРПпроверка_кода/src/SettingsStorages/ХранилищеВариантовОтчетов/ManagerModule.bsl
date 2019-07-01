#Область ПрограммныйИнтерфейс

// Удаляет настройку из хранилища.
//
// Параметры:
//   КлючОтчета - Ключ объекта настройки. 
//       - Неопределено - Удаляются настройки всех отчетов.
//       - Строка       - Полное имя отчета с точкой.
//   КлючВарианта - Ключ удаляемых настроек.
//       - Неопределено - Удаляются все варианты отчета.
//       - Строка       - Ключ варианта отчета.
//   Пользователь - Пользователь, настройки которого удаляются.
//       - Неопределено                   - Удаляются настройки всех пользователей.
//       - Строка                         - Имя пользователя ИБ.
//       - УникальныйИдентификатор        - Идентификатор пользователя ИБ.
//       - ПользовательИнформационнойБазы - Пользователь ИБ.
//       - СправочникСсылка.Пользователи  - Пользователь.
//
// См. также:
//   "СтандартноеХранилищеНастроекМенеджер.Удалить" в синтакс-помощнике.
//
Процедура Удалить(КлючОтчета, КлючВарианта, Пользователь) Экспорт
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Варианты.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.Автор = &Автор
	|	И Варианты.Автор.ИдентификаторПользователяИБ = &GUID
	|	И Варианты.КлючВарианта = &КлючВарианта
	|	И Варианты.ПометкаУдаления = ЛОЖЬ
	|	И Варианты.Пользовательский = ИСТИНА";
	
	Запрос = Новый Запрос;
	
	Если КлючОтчета = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Варианты.Отчет = &Отчет", "ИСТИНА");
	Иначе
		ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(КлючОтчета);
		Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
			ВызватьИсключение ОтчетИнформация.ТекстОшибки;
		КонецЕсли;
		Запрос.УстановитьПараметр("Отчет", ОтчетИнформация.Отчет);
	КонецЕсли;
	
	Если КлючВарианта = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.КлючВарианта = &КлючВарианта", "");
	Иначе
		Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	КонецЕсли;
	
	Если Пользователь = Неопределено Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор = &Автор", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
	
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Запрос.УстановитьПараметр("Администратор", Пользователь);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
		
	Иначе
		
		Если ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
			ИдентификаторПользователя = Пользователь;
		Иначе
			Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
				ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
				Если ПользовательИБ = Неопределено Тогда
					Возврат;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
				ПользовательИБ = Пользователь;
			Иначе
				Возврат;
			КонецЕсли;
			ИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("GUID", ИдентификаторПользователя);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор = &Автор", "");
		
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВариантОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
	
#КонецЕсли
КонецПроцедуры

// Получает список настроек из хранилища. Значениями элементов списка являются ключи настроек.
//
// Параметры:
//   КлючОтчета   - Строка - Полное имя отчета с точкой.
//   Пользователь - Пользователь, настройки которого получаются. Необязательный параметр.
//       - Неопределено                   - Получаются настройки текущего пользователя.
//       - Строка                         - Имя пользователя ИБ.
//       - УникальныйИдентификатор        - Идентификатор пользователя ИБ.
//       - ПользовательИнформационнойБазы - Пользователь ИБ.
//       - СправочникСсылка.Пользователи  - Пользователь.
//
// Возвращаемое значение: 
//   СписокЗначений - Список вариантов отчета.
//       * Значение      - Строка - Ключ варианта.
//       * Представление - Строка - Представление варианта.
//
// Важно:
//   В отличие от механизма платформы вместо права "АдминистрированиеДанных" проверяются права доступа к отчету.
//
// См. также:
//   "СтандартноеХранилищеНастроекМенеджер.ПолучитьСписок" в синтакс-помощнике.
//
Функция ПолучитьСписок(КлючОтчета, Пользователь = Неопределено) Экспорт
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Результат = Новый СписокЗначений;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(КлючОтчета);
		Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
			ВызватьИсключение ОтчетИнформация.ТекстОшибки;
		КонецЕсли;
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Варианты.КлючВарианта,
	|	Варианты.Наименование
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.Автор = &Администратор
	|	И Варианты.Автор.ИдентификаторПользователяИБ = &GUID
	|	И Варианты.ПометкаУдаления = ЛОЖЬ
	|	И Варианты.Пользовательский = ИСТИНА";
	Запрос.УстановитьПараметр("Отчет", ОтчетСсылка);
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	
	Если Пользователь = Неопределено Тогда
		
		Запрос.УстановитьПараметр("Администратор", ТекущийПользователь);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
	
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Запрос.УстановитьПараметр("Администратор", Пользователь);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
		
	Иначе
		
		Если ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
			ИдентификаторПользователя = Пользователь;
		Иначе
			Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
				УстановитьПривилегированныйРежим(Истина);
				ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
				УстановитьПривилегированныйРежим(Ложь);
				Если ПользовательИБ = Неопределено Тогда
					Возврат Результат;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
				ПользовательИБ = Пользователь;
			Иначе
				Возврат Результат;
			КонецЕсли;
			ИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("GUID", ИдентификаторПользователя);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Автор = &Администратор", "");
		
	КонецЕсли;
	
	ТаблицаВариантов = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		Результат.Добавить(СтрокаТаблицы.КлючВарианта, СтрокаТаблицы.Наименование);
	КонецЦикла;
	
	Возврат Результат;
#КонецЕсли
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик чтения настроек варианта отчета.
//
// Параметры:
//   КлючОтчета        - Строка - Полное имя отчета с точкой.
//   КлючВарианта      - Строка - Ключ варианта отчета.
//   Настройки         - Произвольный     - Настройки варианта отчета.
//   ОписаниеНастроек  - ОписаниеНастроек - Дополнительное описание настроек.
//   Пользователь      - Строка           - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаЗагрузки" в синтакс-помощнике.
//
Процедура ОбработкаЗагрузки(КлючОтчета, КлючВарианта, Настройки, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоЧтения() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(КлючОтчета);
		Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
			ВызватьИсключение ОтчетИнформация.ТекстОшибки;
		КонецЕсли;
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Наименование,
	|	ВариантыОтчетов.Настройки
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет = &Отчет
	|	И ВариантыОтчетов.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("Отчет",        ОтчетСсылка);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ОписаниеНастроек = Неопределено Тогда
			ОписаниеНастроек = Новый ОписаниеНастроек;
			ОписаниеНастроек.КлючОбъекта  = КлючОтчета;
			ОписаниеНастроек.КлючНастроек = КлючВарианта;
			ОписаниеНастроек.Пользователь = Пользователь;
		КонецЕсли;
		ОписаниеНастроек.Представление = Выборка.Наименование;
		Настройки = Выборка.Настройки.Получить();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик записи настроек варианта отчета.
//
// Параметры:
//   КлючОтчета        - Строка - Полное имя отчета с точкой.
//   КлючВарианта      - Строка - Ключ варианта отчета.
//   Настройки         - Произвольный         - Настройки варианта отчета.
//   ОписаниеНастроек  - ОписаниеНастроек     - Дополнительное описание настроек.
//   Пользователь      - Строка, Неопределено - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаСохранения" в синтакс-помощнике.
//
Процедура ОбработкаСохранения(КлючОтчета, КлючВарианта, Настройки, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоДобавления() Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав для сохранения вариантов отчетов';uk='Недостатньо прав для збереження варіантів звітів'");
	КонецЕсли;
	
	ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(КлючОтчета);
	
	Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
		ВызватьИсключение ОтчетИнформация.ТекстОшибки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет = &Отчет
	|	И ВариантыОтчетов.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("Отчет",        ОтчетИнформация.Отчет);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда // Для платформы.
			Адрес = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Настройки.ДополнительныеСвойства, "Адрес");
			Если ТипЗнч(Адрес) = Тип("Строка") И ЭтоАдресВременногоХранилища(Адрес) Тогда
				Настройки = ПолучитьИзВременногоХранилища(Адрес);
			КонецЕсли;
		КонецЕсли;
		ВариантОбъект.Настройки = Новый ХранилищеЗначения(Настройки);
		Если ОписаниеНастроек <> Неопределено Тогда
			ВариантОбъект.Наименование = ОписаниеНастроек.Представление;
		КонецЕсли;
		ВариантОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик получения описания настроек варианта отчета.
//
// Параметры:
//   КлючОтчета       - Строка - Полное имя отчета с точкой.
//   КлючВарианта     - Строка - Ключ варианта отчета.
//   ОписаниеНастроек - ОписаниеНастроек     - Дополнительное описание настроек.
//   Пользователь     - Строка, Неопределено - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаПолученияОписания" в синтакс-помощнике.
//
Процедура ОбработкаПолученияОписания(КлючОтчета, КлючВарианта, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоЧтения() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(КлючОтчета);
		Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
			ВызватьИсключение ОтчетИнформация.ТекстОшибки;
		КонецЕсли;
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Если ОписаниеНастроек = Неопределено Тогда
		ОписаниеНастроек = Новый ОписаниеНастроек;
	КонецЕсли;
	
	ОписаниеНастроек.КлючОбъекта  = КлючОтчета;
	ОписаниеНастроек.КлючНастроек = КлючВарианта;
	
	Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
		ОписаниеНастроек.Пользователь = Пользователь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Варианты.Представление КАК Представление,
	|	Варианты.ПометкаУдаления,
	|	Варианты.Пользовательский
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("Отчет",        ОтчетСсылка);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ОписаниеНастроек.Представление = Выборка.Представление;
		ОписаниеНастроек.ДополнительныеСвойства.Вставить("ПометкаУдаления", Выборка.ПометкаУдаления);
		ОписаниеНастроек.ДополнительныеСвойства.Вставить("Пользовательский", Выборка.Пользовательский);
	КонецЕсли;
КонецПроцедуры

// Обработчик установки описания настроек варианта отчета.
//
// Параметры:
//   КлючОтчета       - Строка - Полное имя отчета с точкой.
//   КлючВарианта     - Строка - Ключ варианта отчета.
//   ОписаниеНастроек - ОписаниеНастроек - Дополнительное описание настроек.
//   Пользователь     - Строка           - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаУстановкиОписания" в синтакс-помощнике.
//
Процедура ОбработкаУстановкиОписания(КлючОтчета, КлючВарианта, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоДобавления() Тогда
		ВызватьИсключение НСтр("ru='Недостаточно прав для сохранения вариантов отчетов';uk='Недостатньо прав для збереження варіантів звітів'");
	КонецЕсли;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(КлючОтчета);
		Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
			ВызватьИсключение ОтчетИнформация.ТекстОшибки;
		КонецЕсли;
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Варианты.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("Отчет",        ОтчетСсылка);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВариантОбъект.Наименование = ОписаниеНастроек.Представление;
		ВариантОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти