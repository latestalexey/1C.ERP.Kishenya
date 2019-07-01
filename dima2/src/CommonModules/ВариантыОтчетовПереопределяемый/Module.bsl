////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (сервер, переопределяемый).
// 
// Выполняется на сервере, изменяется под специфику прикладной конфигурации,
// но предназначен для использования только данной подсистемой.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Настройки подсистемы

// Определяет разделы, в которых доступна панель отчетов.
//
// Параметры:
//   Разделы - СписокЗначений - Разделы в которые выведена команды открытия панели отчетов.
//       * Значение - ОбъектМетаданных: Подсистема - Метаданные подсистемы.
//           - Строка - Используется для панели отчетов начальной страницы.
//               В качестве раздела можно указать ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы().
//       * Представление - Строка - Заголовок панели отчетов этого раздела.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех подсистем 1го уровня,
//   в которых размещены команды вызова панелей отчетов.
//
// Например:
//	Разделы.Добавить(Метаданные.Подсистемы.ИмяПодсистемы, <ЗаголовокПанелиОтчетов>);
//	Разделы.Добавить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), <ЗаголовокПанелиОтчетовНачальнойСтраницы>);
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	//++ НЕ УТ
	ЗарплатаКадрыПереопределяемый.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	//-- НЕ УТ
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоПредопределенных().
//
// Описание:
//   В данной процедуре необходимо указать каким именно образом предопределенные варианты отчетов
//   будут регистрироваться в программе и показываться в панели отчетов.
//
// Вспомогательные методы:
//   1. Функции ОписаниеОтчета и ОписаниеВарианта формируют описание настроек отчета и варианта для последующего изменения:
//		НастройкиОтчета   = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//		НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//       Возвращаемые коллекции содержат одинаковый набор свойств.
//       НастройкиОтчета используются как умолчания для вариантов, описания которых еще не получены.
//       
//       Свойства для изменения:
//       * Включен - Булево -
//           Если Ложь, то вариант отчета не регистрируется в подсистеме.
//           Используется для удаления технических и контекстных вариантов отчетов из всех интерфейсов.
//           Эти варианты отчета по прежнему можно открывать в форме отчета программно при помощи
//           параметров открытия (см. справку по "Расширение управляемой формы для отчета.КлючВарианта").
//       * ВидимостьПоУмолчанию - Булево -
//           Если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//           Пользователь может "включить" его в режиме настройки панели отчетов
//           или открыть через форму "Все отчеты".
//       * Описание - Строка - Дополнительная информация по варианту отчета.
//           В панели отчетов выводится в качестве подсказки.
//           Должно расшифровывать для пользователя содержимое варианта отчета
//           и не должно дублировать наименование варианта отчета.
//           Используется при поиске.
//       * Размещение - Соответствие - Настройки размещения варианта отчета в разделах.
//           ** Ключ     - ОбъектМетаданных: Подсистема - Подсистема, в которой размещается отчет или вариант отчета.
//           ** Значение - Строка - Необязательный. Настройки размещения в подсистеме.
//               ""        - Выводить отчет в своей группе обычным шрифтом.
//               СВажный"  - Выводить отчет в своей группе жирным шрифтом.
//               ССмТакже" - Выводить отчет в группе "См. также".
//       * ФункциональныеОпции - Массив из Строка -
//            Имена функциональных опций варианта отчета.
//       * НастройкиДляПоиска - Структура - Дополнительные настройки для поиска этого варианта отчета.
//           Эти настройки необходимо задавать только если СКД не используется или используется не в полном объеме.
//           Например, СКД может использоваться только для параметризации и получения данных,
//           а вывод выполняться в фиксированный макет табличного документа.
//           ** НаименованияПолей - Строка - Имена полей варианта отчета.
//           ** НаименованияПараметровИОтборов - Строка - Имена настроек варианта отчета.
//           ** КлючевыеСлова - Строка - Дополнительная терминология (в т.ч. специализированная или устаревшая).
//           Разделитель терминов: Символы.ПС.
//       * ФорматНастроекСКД - Булево - Отчет использует типовой формат хранения настроек на механике СКД,
//           а его основные формы поддерживают стандартную схему взаимодействия между формами (параметры и тип возвращаемого значения).
//           Если Ложь, тогда для отчета отключаются проверки консистентности и некоторые механизмы, которые рассчитывают на типовой формат.
//       * ОпределитьНастройкиФормы - Булево - Отчет имеет программный интерфейс для тесной интеграции с формой отчета,
//           в том числе может переопределять некоторые настройки формы и подписываться на ее события.
//           Если Истина и отчет подключен к общей форме ФормаОтчета,
//           тогда в модуле объекта отчета следует определить процедуру по шаблону:
//               
//               // Настройки общей формы отчета подсистемы "Варианты отчетов".
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//               //       Неопределено когда вызов без контекста.
//               //   КлючВарианта - Строка, Неопределено - Имя предопределенного
//               //       или уникальный идентификатор пользовательского варианта отчета.
//               //       Неопределено когда вызов без контекста.
//               //   Настройки - Структура - см. возвращаемое значение
//               //       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//               //
//               Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
//               	// Код процедуры.
//               КонецПроцедуры
//               
//   2. Процедура УстановитьРежимВыводаВПанеляхОтчетов позволяет настроить режим группировки вариантов в панелях отчетов:
//		ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//		ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.<ИмяОтчета>, Истина/Ложь);
//		ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Подсистемы.<ИмяПодсистемы>, Истина/Ложь);
//
//   3. Процедура НастроитьОтчетВМодулеМенеджера позволяет переопределять настройки отчета в его модуле менеджера:
//		ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//      После вставки вызова в модуле менеджера указанного отчета следует разместить экспортную процедуру по шаблону:
//      // Настройки размещения в панели отчетов.
//      //
//      // Параметры:
//      //   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//      //   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//      //       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//      //       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Описание:
//      //   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Вспомогательные методы:
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//      //
//      // Примеры:
//      //
//      //  1. Установка описания варианта.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Описание = НСтр("ru='<Описание>'");
//      //
//      //  2. Отключение варианта отчета.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Включен = Ложь;
//      //
//      Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
//      	// Код процедуры.
//      КонецПроцедуры
//
// Примеры:
//
//  1. Добавление варианта отчета в подсистему.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  2. Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
//  3. Отключение всех вариантов отчета, кроме одного.
//	НастройкиОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	НастройкиОтчета.Включен = Ложь;
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Истина;
//
//  4. Заполнение настроек для поиска - наименования полей, параметров и отборов:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчетаБезСхемы, "");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
//		НСтр("ru='Контрагент
//		|Договор
//		|Ответственный
//		|Скидка
//		|Дата'");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
//		НСтр("ru='Период
//		|Ответственный
//		|Контрагент
//		|Договор'");
//
//  5. Переключение режима вывода в панелях отчетов:
//  5.1. Группировка вариантов отчета по этому отчету:
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.ИмяОтчета, Истина);
//  5.2. Без группировки по отчету:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Отчет, Ложь);
//
// Важно:
//   Отчет выступает в качестве контейнера вариантов.
//     Изменяя настройки отчета можно сразу изменять настройки всех его вариантов.
//     Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
//     т.е. более не будут наследовать изменения настроек от отчета. См. пример 3.
//   
//   Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
//     ее дублирование в коде не требуется.
//   
//   Функциональные опции варианта объединяются с функциональными опциями этого отчета по следующим правилам:
//     (ФО1_Отчета ИЛИ ФО2_Отчета) И (ФО3_Варианта ИЛИ ФО4_Варианта).
//   Функциональные опции отчетов не зачитываются из метаданных,
//     они применяются на этапе использования подсистемы пользователем.
//   Через ОписаниеОтчета можно добавлять функциональные опции, которые будут соединяться по указанным выше правилам,
//     но надо помнить, что эти функциональные опции будут действовать только для предопределенных вариантов отчетов.
//   Для пользовательских вариантов отчета действуют только функциональные опции отчета
//     - они отключаются только с отключением всего отчета.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.НастроитьВариантыОтчетов(Настройки);
	
КонецПроцедуры

// Содержит описания изменений имен вариантов отчетов. Используется
//   при обновлении информационной базы, в целях контроля ссылочной целостности
//   и для сохранения настроек варианта, сделанных администратором.
//
// Параметры:
//   Изменения - ТаблицаЗначений - Таблица изменений имен вариантов. Колонки:
//       * Отчет - ОбъектМетаданных - Метаданные отчета, в схеме которого изменилось имя варианта.
//       * СтароеИмяВарианта - Строка - Старое имя варианта, до изменения.
//       * АктуальноеИмяВарианта - Строка - Текущее (последнее актуальное) имя варианта.
//
// Описание:
//   В Изменения необходимо добавить описания изменений имен вариантов
//   отчетов, подключенных к подсистеме.
//
// Например:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
// Важно:
//   Старое имя варианта резервируется и не может быть использовано в дальнейшем.
//   Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
//   указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
//   Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
//   то рекомендуется задавать их таким образом, что бы затем не менять.
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения);
	
КонецПроцедуры

// Глобальные настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Коллекция настроек подсистемы. Реквизиты:
//       * ВыводитьОтчетыВместоВариантов - Булево - Умолчание для вывода гиперссылок в панели отчетов:
//           - Истина - Варианты отчетов по умолчанию скрыты, а отчеты включены и видимы.
//           - Ложь   - Значение по умолчанию. Варианты отчетов по умолчанию видимы, а отчеты отключены.
//       * ВыводитьОписания - Булево - Умолчание для вывода описаний в панели отчетов:
//           - Истина - Значение по умолчанию. Выводить описания в виде подписей под гиперссылками вариантов
//               (режим чтения описаний).
//           - Ложь   - Выводить описания в виде всплывающих подсказок
//               (как раньше).
//       * Поиск - Структура - Настройки поиска вариантов отчетов.
//           * ПодсказкаВвода - Строка - Текст подсказки выводится в поле поиска когда поиск не задан.
//               В качестве примера рекомендуется указывать часто используемые термины прикладной конфигурации.
//       * ДругиеОтчеты - Структура - Настройки формы "Другие отчеты":
//           * ЗакрыватьПослеВыбора - Булево - Закрывать ли форму после выбора гиперссылки отчета.
//               - Истина - Значение по умолчанию. Закрывать "Другие отчеты" после выбора.
//               - Ложь   - Не закрывать.
//           * ПоказыватьФлажок - Булево - Показывать ли флажок ЗакрыватьПослеВыбора.
//               - Истина - Показывать флажок "Закрывать это окно после перехода к другому отчету".
//               - Ложь   - Значение по умолчанию. Не показывать флажок.
//
// Например:
//	Настройки.Поиск.ПодсказкаВвода = НСтр("ru='Например, себестоимость'");
//	Настройки.ДругиеОтчеты.ЗакрыватьПослеВыбора = Ложь;
//	Настройки.ДругиеОтчеты.ПоказыватьФлажок = Истина;
//
Процедура ОпределитьГлобальныеНастройки(Настройки) Экспорт
	
	Настройки.ВыводитьОтчетыВместоВариантов = Истина;
	
	Описание = Новый Структура;
	ИмяФормы = "ОбщаяФорма.ОписаниеМобильногоПриложения";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакетаОписания", "ОписаниеМобильногоПриложенияМониторERP");
	ПараметрыФормы.Вставить("НазваниеПриложения", НСтр("ru='Монитор ERP';uk='Монітор ERP'"));
	СтандартныеПодсистемыКлиентСервер.ВывестиФорму(Описание, ИмяФормы, ПараметрыФормы);
	Настройки.Вставить("ОписаниеМобильногоПриложения", Описание);

КонецПроцедуры

#КонецОбласти
