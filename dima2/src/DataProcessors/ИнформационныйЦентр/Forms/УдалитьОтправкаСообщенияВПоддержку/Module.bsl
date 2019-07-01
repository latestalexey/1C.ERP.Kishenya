////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтКого") Тогда 
		ОтКого = Параметры.ОтКого;
	КонецЕсли;
	
	Если Параметры.Свойство("Текст") Тогда 
		Текст = Параметры.Текст;
		СтрокаПозицияКурсора = НСтр("ru='ПозицияКурсора';uk='ПозицияКурсора'");
		СтрокаКурсора = ОпределитьНомерПозицииДляКурсора(Текст, СтрокаПозицияКурсора) - 9;
		Текст = СтрЗаменить(Текст, СтрокаПозицияКурсора, "");
		Содержание.УстановитьHTML(Текст, Новый Структура);
	КонецЕсли;
	
	Если Параметры.Свойство("Вложения") Тогда 
		Если ТипЗнч(Параметры.Вложения) = Тип("СписокЗначений") Тогда 
			Для каждого СтрокаСписка из Параметры.Вложения Цикл 
				Вложения.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтображатьТему") Тогда 
		Элементы.Тема.Видимость = Параметры.ОтображатьТему;
	КонецЕсли;
	
	ИмяФайлаТехническихПараметров = ИнформационныйЦентрСервер.ПолучитьИмяФайлаТехническихПараметровДляСообщенияВтехПоддержку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МаксимальныйРазмерФайлов = ИнформационныйЦентрКлиент.МаксимальныйРазмерВложенийДляОтправкиСообщенияВПоддержкуСервиса();;
	
	УстановитьКурсорВШаблонеТекста();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПрикрепитьФайл(Элемент)
	
#Если ВебКлиент Тогда
	ОписаниеОповещения = Новый ОписаниеОповещения("ПрикрепитьФайлОповещение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
#Иначе
	ДобавитьВнешниеФайлы(Истина);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайл(Элемент)
	
	Для Итерация = 0 по ВыбираемыеФайлы.Количество() - 1 Цикл 
		
		Если ВыбираемыеФайлы.Получить(Итерация).ИмяКнопкиУдаления = Элемент.Имя Тогда 
			ИндексИмени = ПолучитьИндексЭлементаФормы(Элемент.Имя);
			УдалитьВсеПодчиненныеЭлементы(ИндексИмени);
			УдалитьИзВременногоХранилища(ВыбираемыеФайлы.Получить(Итерация).АдресХранилища);
			ЭлементСписка = Вложения.НайтиПоИдентификатору(ВыбираемыеФайлы.Получить(Итерация).ИдентификаторВСпискеЗначений);
			Если ЭлементСписка <> Неопределено Тогда 
				Вложения.Удалить(ЭлементСписка);
			КонецЕсли;
			ВыбираемыеФайлы.Получить(Итерация).Размер = 0;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отправить(Команда)
	
	Если Не ПроверитьЗаполнениеРеквизитов() Тогда 
		Возврат;
	КонецЕсли;
	
	РезультатОтправки = ОтправитьСообщениеСервер();
	Если РезультатОтправки Тогда 
		ПоказатьОповещениеПользователя(НСтр("ru='Сообщение отправлено.';uk='Повідомлення відправлене.'"));
		Закрыть();
	Иначе
		ОчиститьСообщения();
		ПоказатьСообщениеПользователю(НСтр("ru='К сожалению сообщение не было отправлено.
            |Повторите попытку позже.'
            |;uk='На жаль повідомлення не було відправлене.
            |Повторіть спробу пізніше.'"));
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УдалитьВсеПодчиненныеЭлементы(ИндексЭлемента)
	
	НайденнаяЭлемент = Элементы.Найти("ГруппаФайла" + Строка(ИндексЭлемента));
	Если НайденнаяЭлемент <> Неопределено Тогда 
		Элементы.Удалить(НайденнаяЭлемент);
	КонецЕсли;
	
	НайденнаяЭлемент = Элементы.Найти("ТекстИмениФайла" + Строка(ИндексЭлемента));
	Если НайденнаяЭлемент <> Неопределено Тогда 
		Элементы.Удалить(НайденнаяЭлемент);
	КонецЕсли;
	
	НайденнаяЭлемент = Элементы.Найти("КнопкаУдаленияФайла" + Строка(ИндексЭлемента));
	Если НайденнаяЭлемент <> Неопределено Тогда 
		Элементы.Удалить(НайденнаяЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИндексЭлементаФормы(ИмяЭлемента)
	
	НачалоПозиции = СтрДлина("КнопкаУдаленияФайла") + 1;
	Возврат Число(Сред(ИмяЭлемента, НачалоПозиции));
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
	Если ЗначениеЗаполнено(ОтКого) Тогда
		Попытка
			ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ОтКого);
			Возврат Истина;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
					"ОтКого");
			Возврат Ложь;
		КонецПопытки;
	Иначе 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле Адрес ответа';uk='Не заповнене поле Адреса відповіді'"), ,
			"ОтКого");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПрикрепитьФайлОповещение(Подключено, Контекст) Экспорт
	
	ДобавитьВнешниеФайлы(Подключено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВнешниеФайлы(РасширениеПодключено)
	
	Если РасширениеПодключено Тогда 
		ПоместитьФайлыСРасширением();
	Иначе
		ПоместитьФайлыБезРасширения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлыСРасширением()
	
	// Вызов диалога выбора файлов.
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru='Выберите файл';uk='Виберіть файл'");
	Диалог.МножественныйВыбор = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоместитьФайлСРасширениемОповещение", ЭтотОбъект);
	НачатьПомещениеФайлов(ОписаниеОповещения,, Диалог, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлСРасширениемОповещение(ВыбранныеФайлы, ОбработчикЗавершения) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПолноеИмяФайла = ВыбранныеФайлы.Получить(0).Имя;
	АдресХранилища = ВыбранныеФайлы.Получить(0).Хранение;
	
	// Проверка на корректность общего размера файлов.
	Файл = Новый Файл;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	ДополнительныеПараметры.Вставить("АдресХранилища", АдресХранилища);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьИнициализациюОповещение", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьИнициализацию(ОписаниеОповещения, ПолноеИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьИнициализациюОповещение(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоместитьФайлСРасширениемОповещениеРазмерОповещение", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПолучениеРазмера(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлСРасширениемОповещениеРазмерОповещение(Размер, ДополнительныеПараметры) Экспорт
	
	Если Размер = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ОбщийРазмерФайловОптимален(Размер) Тогда 
		ТекстПредупреждения = НСтр("ru='Не удалось добавить файл. Размер выбранных файлов превышает предел в %1 Мб';uk='Не вдалося додати файл. Розмір вибраних файлів перевищує межу у %1 Мб'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, МаксимальныйРазмерФайлов);
		ОчиститьСообщения();
		ПоказатьСообщениеПользователю(ТекстПредупреждения);
	КонецЕсли;
	
	Состояние(НСтр("ru='Файл добавляется к сообщению.';uk='Файл додається до повідомлення.'"));

	// Добавить файлы в таблицу.
	ИмяИРасширениеФайла = ПолучитьИмяФайла(ДополнительныеПараметры.ПолноеИмяФайла);
	ПоместитьФайлыБезРасширенияНаСервере(ДополнительныеПараметры.АдресХранилища, ИмяИРасширениеФайла);
	
	Состояние();
	
	СоздатьЭлементыФормыДляВложенногоФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлыБезРасширения()
	
	ПослеПомещенияФайловБезРасширения = Новый ОписаниеОповещения(
		"ПослеПомещенияФайловБезРасширения", ЭтотОбъект);
	
	НачатьПомещениеФайла(
		ПослеПомещенияФайловБезРасширения,
		,
		,
		Истина,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайловБезРасширения(Результат, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		ИмяФайла = ПолучитьИмяФайла(ВыбранноеИмяФайла);
		ПоместитьФайлыБезРасширенияНаСервере(АдресХранилища, ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяФайла(Знач ВыбранноеИмяФайла)
	
	Результат = ТехнологияСервисаИнтеграцияСБСП.РазложитьПолноеИмяФайла(ВыбранноеИмяФайла);
	
	Возврат Результат.Имя;
	
КонецФункции

&НаСервере
Процедура ПоместитьФайлыБезРасширенияНаСервере(АдресХранилища, ИмяФайла)
	
	НовыйФайл = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	// Проверка на корректность общего размера файлов.
	РазмерФайла = НовыйФайл.Размер();
	Если Не ОбщийРазмерФайловОптимален(РазмерФайла) Тогда 
		ТекстПредупреждения = НСтр("ru='Размер выбранных файлов превышает предел в %1 Мб';uk='Розмір вибраних файлів перевищує межу у %1 Мб'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, МаксимальныйРазмерФайлов);
		ПоказатьСообщениеПользователю(ТекстПредупреждения);
		УдалитьИзВременногоХранилища(АдресХранилища);
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = ВыбираемыеФайлы.Добавить();
	СтрокаТаблицы.ИмяФайла = ИмяФайла;
	СтрокаТаблицы.Размер = РазмерФайла/1024;
	СтрокаТаблицы.АдресХранилища = АдресХранилища;
	
	СоздатьЭлементыФормыДляВложенногоФайла();
	
КонецПроцедуры

&НаСервере
Функция ОбщийРазмерФайловОптимален(РазмерФайла)
	
	Размер = РазмерФайла / 1024;
	
	// Подсчет общего размера приложенных к письму файлов (с установленной пометкой).
	Для Итерация = 0 по ВыбираемыеФайлы.Количество() - 1 Цикл
		Размер = Размер + (ВыбираемыеФайлы.Получить(Итерация).Размер / 1024);
	КонецЦикла;
	
	РазмерВМегабайтах = Размер / 1024;
	
	Если РазмерВМегабайтах > МаксимальныйРазмерФайлов Тогда 
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПослеПомещенияФайлов(Результат, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		ИмяФайла = ПолучитьИмяФайла(ВыбранноеИмяФайла);
		ПоместитьФайлыБезРасширенияНаСервере(АдресХранилища, ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВСписокОтправляемых()
	
	Для каждого ТекущийФайл из ВыбираемыеФайлы Цикл 
		
		Если ТекущийФайл.ИдентификаторВСпискеЗначений <> 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		ИмяФайла = ТекущийФайл.ИмяФайла;
		АдресХранилища = ТекущийФайл.АдресХранилища;
		НовыйФайлВложения = Вложения.Добавить(ПолучитьИзВременногоХранилища(АдресХранилища), ИмяФайла);
		ТекущийФайл.ИдентификаторВСпискеЗначений = НовыйФайлВложения.ПолучитьИдентификатор();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОтправитьСообщениеСервер()
	
	Текст = "";
	ВложенияHTML = Неопределено;
	Содержание.ПолучитьHTML(Текст, ВложенияHTML);
	
	ПараметрыСообщения = Новый Структура();
	ПараметрыСообщения.Вставить("ОтКого",    ОтКого);
	ПараметрыСообщения.Вставить("Тема",      ОпределитьТему());
	ПараметрыСообщения.Вставить("Текст",     Текст);
	ПараметрыСообщения.Вставить("Вложения",  Вложения);
	ПараметрыСообщения.Вставить("ТипТекста", "HTML");
	
	Результат = Истина;
	ИнформационныйЦентрСервер.ПриОтправкеСообщенияПользователяВТехподдержку(ПараметрыСообщения, Результат);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ОпределитьТему()
	
	Если Не ПустаяСтрока(Тема) Тогда 
		Возврат Тема;
	КонецЕсли;
	
	ТекстСообщения = Содержание.ПолучитьТекст();
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "Здравствуйте!", "");
	
	Возврат СокрЛП(ТекстСообщения);
	
КонецФункции

&НаКлиенте
Процедура УстановитьКурсорВШаблонеТекста()
	
	ПодключитьОбработчикОжидания("ОбработчикУстановитьКурсорВШаблонеТекста", 0.5, Истина);
	
КонецПроцедуры

&НаСервере
Функция ОпределитьНомерПозицииДляКурсора(ТекстПараметр, СтрокаПозицияКурсора)
	
	Возврат СтрНайти(ТекстПараметр, СтрокаПозицияКурсора);
	
КонецФункции

&НаКлиенте
Процедура ОбработчикУстановитьКурсорВШаблонеТекста()
	
	ТекущийЭлемент = Элементы.Содержание;
	Закладка = Содержание.ПолучитьЗакладкуПоПозиции(СтрокаКурсора);
	Элементы.Содержание.УстановитьГраницыВыделения(Закладка, Закладка);
	
КонецПроцедуры

&НаСервере
Функция СоздатьЭлементыФормыДляВложенногоФайла()
	
	Для Итерация = 0 по ВыбираемыеФайлы.Количество() - 1 Цикл
		
		Если Не ПустаяСтрока(ВыбираемыеФайлы.Получить(Итерация).ИмяКнопкиУдаления) Тогда 
			Продолжить;
		КонецЕсли;
		
		ГруппаФайла							= Элементы.Добавить("ГруппаФайла" + Строка(Итерация), Тип("ГруппаФормы"), Элементы.ГруппаПрикрепленныхФайлов);
		ГруппаФайла.Вид						= ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаФайла.ОтображатьЗаголовок		= Ложь;
		ГруппаФайла.Группировка				= ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаФайла.Отображение				= ОтображениеОбычнойГруппы.Нет;
		
		ТекстИмениФайла						= Элементы.Добавить("ТекстИмениФайла" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаФайла);
		ТекстИмениФайла.Вид					= ВидДекорацииФормы.Надпись;
		ТекстИмениФайла.Заголовок			= ВыбираемыеФайлы.Получить(Итерация).ИмяФайла + " (" + ВыбираемыеФайлы.Получить(Итерация).Размер + " Кб)";
		
		КнопкаУдаленияФайла					= Элементы.Добавить("КнопкаУдаленияФайла" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаФайла);
		КнопкаУдаленияФайла.Вид				= ВидДекорацииФормы.Картинка;
		КнопкаУдаленияФайла.Картинка		= БиблиотекаКартинок.УдалитьНепосредственно;
		КнопкаУдаленияФайла.Подсказка		= НСтр("ru='Удалить файл';uk='Вилучити файл'");
		КнопкаУдаленияФайла.Ширина			= 2;
		КнопкаУдаленияФайла.Высота			= 1;
		КнопкаУдаленияФайла.РазмерКартинки	= РазмерКартинки.Растянуть;
		КнопкаУдаленияФайла.Гиперссылка		= Истина;
		КнопкаУдаленияФайла.УстановитьДействие("Нажатие", "УдалитьФайл");
		
		ВыбираемыеФайлы.Получить(Итерация).ИмяКнопкиУдаления = КнопкаУдаленияФайла.Имя;
		
	КонецЦикла;
	
	// Подключается обработчик ожидания добавления файла.
	ДобавитьФайлыВСписокОтправляемых();
	
КонецФункции

&НаСервере
Функция ПоказатьСообщениеПользователю(Текст)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();
	
КонецФункции