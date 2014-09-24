<?php
/**
 * Gymia Pre-Job Test
 * URL Shortner
 * Database Connection
 *
 * @author      MarQuis Knox <hire@marquisknox.com>
 * @copyright   2014 MarQuis Knox
 * @link        http://marquisknox.com
 * @license     GNU Affero General Public License
 * @license     http://www.gnu.org/licenses/agpl-3.0.html
 *
 * @since       Wednesday, September 24, 2014, 05:43 AM GMT+1 mknox
 * @edited      $Date$ $Author$
 * @version     $Id$
 *
 * @category    Site Index
 * @package     Gymia Pre-Job Test
*/

$config     = new Zend_Config_Ini( dirname(__FILE__).'/db.ini', 'dev' );
$options    = $config->params->toArray();

try {
    $db = Zend_Db::factory( $config->adapter, $options );
    Zend_Db_Table_Abstract::setDefaultAdapter( $db );
    Zend_Registry::set( 'dbAdapter', $db );
    define( 'DB_TABLE_PREFIX', $options['table_prefix'] );
} catch ( Exception $e ) {
    exit( $e->getMessage() );
}