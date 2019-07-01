////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиКлиентСервер: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает текстовое представление версии электронного документа.
//
// Параметры:
//  СсылкаНаВладельца - Ссылка на объект ИБ, состояние версии электронного документа которого необходимо получить.
//
Функция ПолучитьТекстСостоянияЭД(СсылкаНаВладельца, Форма = Неопределено) Экспорт
	
	Гиперссылка = Ложь;
	Результат = ОбменСКонтрагентамиСлужебныйВызовСервера.ТекстСостоянияЭД(СсылкаНаВладельца, Гиперссылка);
	
	Если НЕ Форма = Неопределено Тогда
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ТекстСостоянияЭДО", Результат);
		СтруктураПараметров.Вставить("ВидОперации", "УстановкаГиперссылки");
		СтруктураПараметров.Вставить("ЗначениеПараметра", Гиперссылка);
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			ЭлектронноеВзаимодействиеПереопределяемый.ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров);
		#Иначе
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров);
		#КонецЕсли
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует текстовое представление рекламы по ЭДО.
//
// Параметры:
//
// ДополнительнаяИнформация - Структура - с полями:
// * Картинка - Картинка - картинка из библиотеки картинок;
// * Текст - Строка - форматированный текст надписи с навигационными ссылками.
//
// МассивСсылок- Массив - список ссылок на объекты.
Функция ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок) Экспорт
	
	Если Не ЗначениеЗаполнено(МассивСсылок) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЕстьПравоНастройкиЭДО(Ложь) Тогда
		Возврат "";
	КонецЕсли;
	
	ПараметыЭД = Неопределено;
	Если Не ОбменСКонтрагентамиСлужебныйВызовСервера.НастройкаЭДСуществует(МассивСсылок[0], ПараметыЭД) Тогда
		
		ТекстНавигационнойСсылки = "";
		ОбменСКонтрагентамиСлужебныйВызовСервера.ЗаполнитьТекстПриглашенияКЭДО(ТекстНавигационнойСсылки, ПараметыЭД, МассивСсылок[0], Ложь);
		Если ЗначениеЗаполнено(ТекстНавигационнойСсылки) Тогда
			ШаблонНавигационнойСсылки = НСтр("ru='<a href = ""Гиперссылка"">%1</a>';uk='<a href = ""Гіперпосилання"">%1</a>'");
			ДополнительнаяИнформация.Текст    = СтрШаблон(ШаблонНавигационнойСсылки, ТекстНавигационнойСсылки);
			ДополнительнаяИнформация.Картинка = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// В процедуре выполняются действия по служебным ЭД (извещение о получении, уведомление об уточнении):
// формирование, утверждение, подписание, отправка.
//
// Параметры:
//  МассивЭД - массив - содержит ссылки на ЭД, по которым требуется сформировать служебные ЭД (электронные
//    документы, владельцы обрабатываемых служебных ЭД).
//  ВидЭД - перечисление - вид ЭД, которые надо обработать (может принимать значения: Извещение о получении
//    и уведомление об уточнении).
//  ТекстУведомления - строка - текст уведомления, введенный пользователем, отклонившим ЭД (имеет смысл,
//    только для ВидЭД = УведомлениеОбУточнении).
//  ДопПараметры - структура - структура дополнительных параметров
//
Процедура СформироватьПодписатьИОтправитьСлужебныеЭД(МассивЭД,
	ВидЭД, ТекстУведомления = "", ДопПараметры = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	КолСформированных = 0;
	КолУтвержденных   = 0;
	КолПодписанных    = 0;
	КолПодготовленных = 0;
	КолОтправленных   = 0;
	// Структура соответствий содержит соответствия: соглашений и сертификатов подписи, соглашений и сертификатов авторизации,
	// сертификатов и структур параметров этих сертификатов (структура параметров сертификатов содержит: ссылку на сертификат,
	// признак "запомнить пароль к сертификату", пароль к сертификату, признак "отозван", отпечаток, файл сертификата, а так же
	// если этот сертификат используется для авторизации, то либо расшифрованный маркер, либо зашифрованный маркер или и то и другое).
	НемедленнаяОтправкаЭД = Неопределено;
	ВыполнятьКриптооперацииНаСервере = Неопределено;
	ОбменСКонтрагентамиСлужебныйВызовСервера.ИнициализироватьПеременные(
		ВыполнятьКриптооперацииНаСервере, НемедленнаяОтправкаЭД);
	Если МассивЭД.Количество() > 0 И ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.ИзвещениеОПолучении") Тогда
		ОбменСКонтрагентамиСлужебныйВызовСервера.УдалитьИзМассиваНеОбрабатываемыеЭД(МассивЭД);
	КонецЕсли;
	ВыполнитьОповещение = (ОписаниеОповещения <> Неопределено);
	Если МассивЭД.Количество() > 0 Тогда
		МассивСлужебныхЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.СформироватьСлужебныеЭД(МассивЭД, ВидЭД, ТекстУведомления);
		Если ЗначениеЗаполнено(МассивСлужебныхЭД) Тогда
			СтМассивовСтруктурСертификатов = Новый Структура;
			Действия = "ПодписатьОтправить";
			#Если Клиент Тогда
				ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(Новый Массив,
					Действия, ДопПараметры, МассивСлужебныхЭД, ОписаниеОповещения);
				ВыполнитьОповещение = Ложь;
			#Иначе
				СтруктураСоответствий = Неопределено;
				СтСоотвСоглашенийИМассивовЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.ВыполнитьДействияПоЭД(Новый Массив,
					Новый Массив, Действия, ДопПараметры, МассивСлужебныхЭД, СтруктураСоответствий);
			#КонецЕсли
		КонецЕсли;
	КонецЕсли;
	Если ВыполнитьОповещение И ТипЗнч(ОписаниеОповещения) = Тип("ОписаниеОповещения") Тогда
		#Если Клиент Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОповещения);
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти