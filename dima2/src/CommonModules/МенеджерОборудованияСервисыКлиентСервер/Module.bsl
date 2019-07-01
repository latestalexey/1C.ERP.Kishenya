
// Функция возвращает пустую структуру настроек.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруНастроек() Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("НазваниеОрганизации", "");
	СтруктураНастроек.Вставить("ИНН", "");
	СтруктураНастроек.Вставить("Налогообложение", "");
	СтруктураНастроек.Вставить("ИспользоватьСкидки", Ложь);
	СтруктураНастроек.Вставить("ИспользоватьБанковскиеКарты", Ложь);
	
	СтруктураНастроек.Вставить("ВидыОплаты", Новый Массив);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Видов оплаты".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваВидыОплаты() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Наименование");
	СтруктураЗаписи.Вставить("ТипОплаты");
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруПрайсЛиста() Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.ПолучитьСтруктуруПрайсЛиста();
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Товары" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТовары() Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТовары();
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Характеристики" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваХарактеристики() Экспорт
	
	СтруктураЗаписиМассиваХарактеристики = Новый Структура;
	
	СтруктураЗаписиМассиваХарактеристики.Вставить("Код");
	СтруктураЗаписиМассиваХарактеристики.Вставить("Наименование");
	СтруктураЗаписиМассиваХарактеристики.Вставить("ИмеетУпаковки", Ложь);
	СтруктураЗаписиМассиваХарактеристики.Вставить("Упаковки", Новый Массив());
	СтруктураЗаписиМассиваХарактеристики.Вставить("Штрихкод");
	СтруктураЗаписиМассиваХарактеристики.Вставить("Остаток");
	СтруктураЗаписиМассиваХарактеристики.Вставить("Цена");
	
	Возврат СтруктураЗаписиМассиваХарактеристики;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Упаковки" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваУпаковки() Экспорт
	
	СтруктураЗаписиМассиваУпаковки = Новый Структура;
	
	СтруктураЗаписиМассиваУпаковки.Вставить("Код");
	СтруктураЗаписиМассиваУпаковки.Вставить("Наименование");
	СтруктураЗаписиМассиваУпаковки.Вставить("Штрихкод");
	СтруктураЗаписиМассиваУпаковки.Вставить("Остаток");
	СтруктураЗаписиМассиваУпаковки.Вставить("Цена");
	СтруктураЗаписиМассиваУпаковки.Вставить("Коэффициент");
	
	Возврат СтруктураЗаписиМассиваУпаковки;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Группы товаров" прайс-листа.
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваГруппыТоваров() Экспорт
	
	СтруктураЗаписиМассиваГруппыТоваров = Новый Структура;
	
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("Код",          "");
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("КодГруппы",    "");
	СтруктураЗаписиМассиваГруппыТоваров.Вставить("Наименование", "");
	
	Возврат СтруктураЗаписиМассиваГруппыТоваров;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Типы документов".
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТиповДокументов() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("ТипДокумента");
	СтруктураЗаписи.Вставить("МожноПолучать");
	СтруктураЗаписи.Вставить("МожноЗагружать");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Типы документов"
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруОтветаПриЗагрузке() Экспорт
	
	СтруктураОтветаПриЗагрузке = Новый Структура;
	
	СтруктураОтветаПриЗагрузке.Вставить("Успешно", Ложь);
	СтруктураОтветаПриЗагрузке.Вставить("Описание", "");
	
	Возврат СтруктураОтветаПриЗагрузке;
	
КонецФункции

// Функция возвращает пустую структуру загружаемого документа.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗагружаемогоДокумента() Экспорт
	
	СтруктураЗагружаемогоДокумента = Новый Структура;
	
	СтруктураЗагружаемогоДокумента.Вставить("ТипДокумента");
	СтруктураЗагружаемогоДокумента.Вставить("Обработан");
	СтруктураЗагружаемогоДокумента.Вставить("Документы", Новый Массив);
	
	Возврат СтруктураЗагружаемогоДокумента;
	
КонецФункции

// Функция возвращает пустую структуру отчета о продажах. 
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруОтчетаОПродажах() Экспорт
	
	СтруктураОтчетаОПродажах = Новый Структура;
	
	СтруктураОтчетаОПродажах.Вставить("Товары", Новый Массив);
	СтруктураОтчетаОПродажах.Вставить("Оплаты", Новый Массив);
	СтруктураОтчетаОПродажах.Вставить("НомерСмены",);
	СтруктураОтчетаОПродажах.Вставить("ДатаОткрытияСмены",);
	СтруктураОтчетаОПродажах.Вставить("ДатаЗакрытияСмены",);
	
	Возврат СтруктураОтчетаОПродажах;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Товары" отчета о продажах.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТоварыОтчетаОПродажах() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Цена");
	СтруктураЗаписи.Вставить("Сумма");
	СтруктураЗаписи.Вставить("Количество");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Оплаты" отчета о продажах.
// Для разбора XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваОплаты() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("ТипОплаты");
	СтруктураЗаписи.Вставить("Сумма");
	СтруктураЗаписи.Вставить("КодВидаОплаты");
	
	Возврат СтруктураЗаписи;
	
КонецФункции
